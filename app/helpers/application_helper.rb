module ApplicationHelper
  def link_to_with_sort(name, table_column)
    link_to name, sort: table_column
  end
end