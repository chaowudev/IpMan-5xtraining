module ApplicationHelper
  def sortable(column, link_name)
    link_to link_name, sort: column
  end
end
