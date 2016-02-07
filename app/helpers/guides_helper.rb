module GuidesHelper

  def link(name)
    @guide = Guide.find_by_name(name)
    link_to name, @guide
  end
end
