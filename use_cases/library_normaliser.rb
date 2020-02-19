class LibraryNormaliser
  def initialize(record, normalised_fields)
    @record = record
    @normalised_fields = normalised_fields
  end

  def call
    library
  end

  def method_missing(m, *args, &block)
    if(normalised_fields.include?(m.to_s))
      raise(
        StandardError, "This is an LibraryNormaliser class - please implement #{m}"
      )
    end
  end

  protected

  attr_reader :record, :normalised_fields

  def library
    @library ||=
      {}.tap{ |library| normalised_fields.each{ |field| library[field.to_sym] = public_send(field) } }
  end
end
