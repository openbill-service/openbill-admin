# Вот так хулиганим, чтобы в JsonbInput выходило красивое значение
#
class Hash
  def to_s
    to_json
  end
end
