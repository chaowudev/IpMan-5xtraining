module ApplicationHelper
  def link_to_with_sort(name, table_column)
    link_to name, sort: table_column
  end

  def link_to_with_sort_as_asc_or_desc(name, table_column)
    direction = params[:direction] == 'asc' ? 'desc' : 'asc'
    link_to name, sort: table_column, direction: direction
  end
end