# -*- coding: utf-8 -*-
require "sprockets_test"

require 'rack/builder'
require 'rack/test'

class TestServer < Sprockets::TestCase
  include Rack::Test::Methods

  def setup
    @env = Sprockets::Environment.new
    @env.append_path(fixture_path("server/app/javascripts"))
    @env.append_path(fixture_path("server/vendor/javascripts"))
    @env.append_path(fixture_path("server/vendor/stylesheets"))
  end

  def default_app
    env = @env

    Rack::Builder.new do
      map "/assets" do
        run env
      end

      map "/cached/javascripts" do
        run env.cached
      end
    end
  end

  def app
    @app ||= default_app
  end

  test "serve single source file" do
    get "/assets/foo.js"
    assert_equal 200, last_response.status
    assert_equal "9", last_response.headers['Content-Length']
    assert_equal "Accept-Encoding", last_response.headers['Vary']
    assert_equal "var foo;\n", last_response.body
  end

  test "serve single source file body" do
    get "/assets/foo.js?body=1"
    assert_equal 200, last_response.status
    assert_equal "9", last_response.headers['Content-Length']
    assert_equal "var foo;\n", last_response.body
  end

  test "serve gzip'd source file" do
    get "/assets/foo.js", {}, 'HTTP_ACCEPT_ENCODING' => 'gzip'
    assert_equal 200, last_response.status
    assert_equal "application/javascript", last_response.headers['Content-Type']
    assert_equal "gzip", last_response.headers['Content-Encoding']
    assert_equal "29", last_response.headers['Content-Length']
    assert_equal "Accept-Encoding", last_response.headers['Vary']
    assert_equal [31, 139, 8, 0], last_response.body.bytes.take(4)
  end

  test "serve deflate'd source file" do
    get "/assets/foo.js", {}, 'HTTP_ACCEPT_ENCODING' => 'deflate'
    assert_equal 200, last_response.status
    assert_equal "application/javascript", last_response.headers['Content-Type']
    assert_equal "deflate", last_response.headers['Content-Encoding']
    assert_equal "11", last_response.headers['Content-Length']
    assert_equal "Accept-Encoding", last_response.headers['Vary']
    assert_equal [43, 75, 44, 82], last_response.body.bytes.take(4)
  end

  test "serve gzip'd static file" do
    get "/assets/hello.txt", {}, 'HTTP_ACCEPT_ENCODING' => 'gzip'
    assert_equal 200, last_response.status
    assert_equal "text/plain; charset=utf-8", last_response.headers['Content-Type']
    assert_equal "gzip", last_response.headers['Content-Encoding']
    assert_equal "53", last_response.headers['Content-Length']
    assert_equal "Accept-Encoding", last_response.headers['Vary']
    assert_equal [31, 139, 8, 0], last_response.body.bytes.take(4)
  end

  test "ignore unknown encoding and fallback to gzip" do
    get "/assets/foo.js", {}, 'HTTP_ACCEPT_ENCODING' => 'sdch, gzip'
    assert_equal 200, last_response.status
    assert_equal "application/javascript", last_response.headers['Content-Type']
    assert_equal "gzip", last_response.headers['Content-Encoding']
    assert_equal "29", last_response.headers['Content-Length']
    assert_equal "Accept-Encoding", last_response.headers['Vary']
    assert_equal [31, 139, 8, 0], last_response.body.bytes.take(4)
  end

  test "ignore unknown encoding and fallback to identity" do
    get "/assets/foo.js", {}, 'HTTP_ACCEPT_ENCODING' => 'sdch, identity, gzip'
    assert_equal 200, last_response.status
    assert_equal nil, last_response.headers['Content-Encoding']
    assert_equal "9", last_response.headers['Content-Length']
    assert_equal "Accept-Encoding", last_response.headers['Vary']
    assert_equal "var foo;\n", last_response.body
  end

  test "content encoded etag is distinct from unencoded etag" do
    get "/assets/foo.js", {}, 'HTTP_ACCEPT_ENCODING' => 'identity'
    assert_equal 200, last_response.status
    refute last_response.headers['Content-Encoding']
    assert etag = last_response.headers['ETag']

    get "/assets/foo.js", {}, 'HTTP_ACCEPT_ENCODING' => 'gzip'
    assert_equal 200, last_response.status
    assert_equal "gzip", last_response.headers['Content-Encoding']
    refute_equal etag, last_response.headers['ETag']
  end

  test "ignores accept encoding when url is fingerprinted" do
    get "/assets/foo.js"
    digest = last_response.headers['ETag'][/"(.+)"/, 1]

    get "/assets/foo-#{digest}.js", {}, 'HTTP_ACCEPT_ENCODING' => 'gzip'
    assert_equal 200, last_response.status
    assert_equal "application/javascript", last_response.headers['Content-Type']
    assert_equal "9", last_response.headers['Content-Length']
    assert_match %r{max-age}, last_response.headers['Cache-Control']
    refute last_response.headers['Content-Encoding']
    refute last_response.headers['Vary']
  end

  test "serve single source file from cached environment" do
    get "/cached/javascripts/foo.js"
    assert_equal "var foo;\n", last_response.body
  end

  test "serve source with dependencies" do
    get "/assets/application.js"
    assert_equal "var foo;\n\n(function() {\n  application.boot();\n})();\n",
      last_response.body
  end

  test "serve source file body that has dependencies" do
    get "/assets/application.js?body=true"
    assert_equal 200, last_response.status
    assert_equal "\n(function() {\n  application.boot();\n})();\n",
      last_response.body
    assert_equal "43", last_response.headers['Content-Length']
  end

  test "serve source with content type headers" do
    get "/assets/application.js"
    assert_equal "application/javascript", last_response.headers['Content-Type']

    get "/assets/bootstrap.css"
    assert_equal "text/css; charset=utf-8", last_response.headers['Content-Type']
  end

  test "serve source with etag headers" do
    digest = @env['application.js'].digest

    get "/assets/application.js"
    assert_equal "\"#{digest}\"",
      last_response.headers['ETag']
  end

  test "not modified partial response when if-none-match etags match" do
    get "/assets/application.js"
    assert_equal 200, last_response.status
    etag, cache_control, expires, vary = last_response.headers.values_at(
      'ETag', 'Cache-Control', 'Expires', 'Vary'
    )

    get "/assets/application.js", {},
      'HTTP_IF_NONE_MATCH' => etag

    assert_equal 304, last_response.status

    # Allow 304 headers
    assert_equal cache_control, last_response.headers['Cache-Control']
    assert_equal etag, last_response.headers['ETag']
    assert_equal expires, last_response.headers['Expires']
    assert_equal vary, last_response.headers['Vary']

    # Disallowed 304 headers
    refute last_response.headers['Content-Type']
    refute last_response.headers['Content-Length']
    refute last_response.headers['Content-Encoding']
  end

  test "response when if-none-match etags don't match" do
    get "/assets/application.js", {},
      'HTTP_IF_NONE_MATCH' => "nope"

    assert_equal 200, last_response.status
    assert_equal '"6413e7ce345409919a84538cb5577e2cd17bb72f"', last_response.headers['ETag']
    assert_equal '52', last_response.headers['Content-Length']
  end

  test "not modified partial response with fingerprint and if-none-match etags match" do
    get "/assets/application.js"
    assert_equal 200, last_response.status

    etag   = last_response.headers['ETag']
    digest = etag[/"(.+)"/, 1]

    get "/assets/application-#{digest}.js", {},
      'HTTP_IF_NONE_MATCH' => etag
    assert_equal 304, last_response.status
  end

  test "ok response with fingerprint and if-nonematch etags don't match" do
    get "/assets/application.js"
    assert_equal 200, last_response.status

    etag   = last_response.headers['ETag']
    digest = etag[/"(.+)"/, 1]

    get "/assets/application-#{digest}.js", {},
      'HTTP_IF_NONE_MATCH' => "nope"
    assert_equal 200, last_response.status
  end

  test "not found with if-none-match" do
    get "/assets/missing.js", {},
      'HTTP_IF_NONE_MATCH' => '"000"'
    assert_equal 404, last_response.status
  end

  test "not found fingerprint with if-none-match" do
    get "/assets/missing-6413e7ce345409919a84538cb5577e2cd17bb72f.js", {},
      'HTTP_IF_NONE_MATCH' => '"6413e7ce345409919a84538cb5577e2cd17bb72f"'
    assert_equal 404, last_response.status
  end

  test "not found with response with incorrect fingerprint and matching if-none-match etags" do
    get "/assets/application.js"
    assert_equal 200, last_response.status

    etag = last_response.headers['ETag']

    get "/assets/application-0000000000000000000000000000000000000000.js", {},
      'HTTP_IF_NONE_MATCH' => etag
    assert_equal 404, last_response.status
  end

  test "ok partial response when if-match etags match" do
    get "/assets/application.js"
    assert_equal 200, last_response.status
    etag = last_response.headers['ETag']

    get "/assets/application.js", {},
      'HTTP_IF_MATCH' => etag

    assert_equal 200, last_response.status
    assert_equal '"6413e7ce345409919a84538cb5577e2cd17bb72f"', last_response.headers['ETag']
    assert_equal '52', last_response.headers['Content-Length']
  end

  test "precondition failed with if-match is a mismatch" do
    get "/assets/application.js", {},
      'HTTP_IF_MATCH' => '"000"'
    assert_equal 412, last_response.status

    refute last_response.headers['ETag']
  end

  test "not found with if-match" do
    get "/assets/missing.js", {},
      'HTTP_IF_MATCH' => '"000"'
    assert_equal 404, last_response.status
  end

  test "if sources didnt change the server shouldnt rebundle" do
    get "/assets/application.js"
    asset_before = @env["application.js"]
    assert asset_before

    get "/assets/application.js"
    asset_after = @env["application.js"]
    assert asset_after

    assert asset_before.eql?(asset_after)
  end

  test "fingerprint digest sets expiration to the future" do
    get "/assets/application.js"
    digest = last_response.headers['ETag'][/"(.+)"/, 1]

    get "/assets/application-#{digest}.js"
    assert_equal 200, last_response.status
    assert_match %r{max-age}, last_response.headers['Cache-Control']
  end

  test "bad fingerprint digest returns a 404" do
    get "/assets/application-0000000000000000000000000000000000000000.js"
    assert_equal 404, last_response.status
  end

  test "missing source" do
    get "/assets/none.js"
    assert_equal 404, last_response.status
    assert_equal "pass", last_response.headers['X-Cascade']
  end

  test "re-throw JS exceptions in the browser" do
    get "/assets/missing_require.js"
    assert_equal 200, last_response.status
    assert_equal "throw Error(\"Sprockets::FileNotFound: couldn't find file 'notfound' with type 'application/javascript'\\n  (in #{fixture_path("server/vendor/javascripts/missing_require.js")}:1)\")", last_response.body
  end

  test "display CSS exceptions in the browser" do
    get "/assets/missing_require.css"
    assert_equal 200, last_response.status
    assert_match %r{content: ".*?Sprockets::FileNotFound}, last_response.body
  end

  test "serve encoded utf-8 filename" do
    get "/assets/%E6%97%A5%E6%9C%AC%E8%AA%9E.js"
    assert_equal "var japanese = \"日本語\";\n", last_response.body
  end

  test "illegal require outside load path" do
    get "/assets/../config/passwd"
    assert_equal 403, last_response.status

    get "/assets/%2e%2e/config/passwd"
    assert_equal 403, last_response.status
  end

  test "add new source to tree" do
    filename = fixture_path("server/app/javascripts/baz.js")

    sandbox filename do
      get "/assets/tree.js"
      assert_equal "var foo;\n\n(function() {\n  application.boot();\n})();\nvar bar;\nvar japanese = \"日本語\";\n", last_response.body

      File.open(filename, "w") do |f|
        f.puts "var baz;"
      end

      path = fixture_path "server/app/javascripts"
      mtime = Time.now + 60
      File.utime(mtime, mtime, path)

      get "/assets/tree.js"
      assert_equal "var foo;\n\n(function() {\n  application.boot();\n})();\nvar bar;\nvar baz;\nvar japanese = \"日本語\";\n", last_response.body
    end
  end

  test "serving static assets" do
    get "/assets/hello.txt"
    assert_equal 200, last_response.status
    assert_equal "text/plain", last_response.content_type
    assert_equal File.read(fixture_path("server/app/javascripts/hello.txt")), last_response.body
  end

  test "disallow non-get methods" do
    get "/assets/foo.js"
    assert_equal 200, last_response.status

    post "/assets/foo.js"
    assert_equal 405, last_response.status

    put "/assets/foo.js"
    assert_equal 405, last_response.status

    delete "/assets/foo.js"
    assert_equal 405, last_response.status
  end
end
