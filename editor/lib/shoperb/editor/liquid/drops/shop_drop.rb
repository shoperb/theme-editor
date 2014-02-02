class ShopDrop < Liquid::Drop

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def name
    record.name
  end

  def domain
    record.external_hostname
  end

  def meta_title
    record.meta_title
  end

  def meta_keywords
    record.meta_keywords
  end

  def meta_description
    record.meta_description
  end

  def current?
    record.id == Shop.current.id
  end

  def metric?
    record.metric?
  end

  def address
    AddressDrop.new(record.address)
  end

  def language
    LanguageDrop.new(record.language)
  end

  def current_locale
    I18n.locale.to_s
  end

  def possible_languages
    record.possible_languages
  end

  def currency
    CurrencyDrop.new(record.currency)
  end

  def account
    AccountDrop.new(record.account)
  end

  def to_s
    "#<Shop name: '#{name}'>"
  end

  def inspect
    to_s
  end

end