class Array
  def to_relation(klass)
    Shoperb::Theme::Editor::Mounter::Model::Relation.build(self, klass)
  end
end
