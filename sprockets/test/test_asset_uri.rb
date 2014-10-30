require 'sprockets_test'
require 'sprockets/asset_uri'

class TestAssetURI < Sprockets::TestCase
  test "parse file paths" do
    assert_equal ["/usr/local/var/github/app/assets/javascripts/application.js", {}],
      Sprockets::AssetURI.parse("file:///usr/local/var/github/app/assets/javascripts/application.js")
    assert_equal ["/usr/local/var/github/app/assets/javascripts/foo bar.js", {}],
      Sprockets::AssetURI.parse("file:///usr/local/var/github/app/assets/javascripts/foo%20bar.js")
  end

  test "parse query params" do
    assert_equal ["/usr/local/var/github/app/assets/javascripts/application.coffee", {type: 'application/javascript'}],
      Sprockets::AssetURI.parse("file:///usr/local/var/github/app/assets/javascripts/application.coffee?type=application/javascript")
    assert_equal ["/usr/local/var/github/app/assets/images/logo.png", {encoding: 'gzip'}],
      Sprockets::AssetURI.parse("file:///usr/local/var/github/app/assets/images/logo.png?encoding=gzip")
    assert_equal ["/usr/local/var/github/app/assets/stylesheets/users.css", {type: 'text/css', flag: true}],
      Sprockets::AssetURI.parse("file:///usr/local/var/github/app/assets/stylesheets/users.css?type=text/css&flag")
  end

  test "raise erorr when invalid uri scheme" do
    assert_raises URI::InvalidURIError do
      Sprockets::AssetURI.parse("http:///usr/local/var/github/app/assets/javascripts/application.js")
    end
  end

  test "build file path" do
    assert_equal "file:///usr/local/var/github/app/assets/javascripts/application.js",
      Sprockets::AssetURI.build("/usr/local/var/github/app/assets/javascripts/application.js")
    assert_equal "file:///usr/local/var/github/app/assets/javascripts/foo%20bar.js",
      Sprockets::AssetURI.build("/usr/local/var/github/app/assets/javascripts/foo bar.js")
  end

  test "build query params" do
    assert_equal "file:///usr/local/var/github/app/assets/javascripts/application.coffee?type=application/javascript",
      Sprockets::AssetURI.build("/usr/local/var/github/app/assets/javascripts/application.coffee", type: 'application/javascript')
    assert_equal "file:///usr/local/var/github/app/assets/images/logo.svg?type=image/svg+xml",
      Sprockets::AssetURI.build("/usr/local/var/github/app/assets/images/logo.svg", type: 'image/svg+xml')
    assert_equal "file:///usr/local/var/github/app/assets/stylesheets/users.css?type=text/css&flag",
      Sprockets::AssetURI.build("/usr/local/var/github/app/assets/stylesheets/users.css", type: 'text/css', flag: true)
    assert_equal "file:///usr/local/var/github/app/assets/stylesheets/users.css?type=text/css",
      Sprockets::AssetURI.build("/usr/local/var/github/app/assets/stylesheets/users.css", type: 'text/css', flag: false)
    assert_equal "file:///usr/local/var/github/app/assets/images/logo.png?encoding=gzip",
      Sprockets::AssetURI.build("/usr/local/var/github/app/assets/images/logo.png", encoding: 'gzip')
    assert_equal "file:///usr/local/var/github/app/assets/images/logo.png",
      Sprockets::AssetURI.build("/usr/local/var/github/app/assets/images/logo.png", encoding: nil)
  end

  test "raise error when invalid param value" do
    assert_raises TypeError do
      Sprockets::AssetURI.build("/usr/local/var/github/app/assets/images/logo.png", encodings: ['gzip', 'deflate'])
    end
  end

  test "merge params" do
    assert_equal "file:///usr/local/var/github/app/assets/javascripts/application.coffee?type=text/coffeescript&encoding=gzip&flag",
      Sprockets::AssetURI.merge("file:///usr/local/var/github/app/assets/javascripts/application.coffee?type=application/javascript&encoding=gzip", type: 'text/coffeescript', flag: true)
  end
end
