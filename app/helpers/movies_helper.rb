module MoviesHelper
  # Part 2 adds helper methods here, to keep the logic behind the sortable
  # Column Headers
  def sorted_by?(column)
    @sort_by.to_s == column.to_s
  end

  def sort_aria(column)
    sorted_by?(column) ? 'ascending' : 'none'
  end

  def sort_classes(column)
    'hilite bg-info text-dark' if sorted_by?(column)
  end
  # Adding in weird indicator thing
  def sort_indicator(column)
    tag.span(' ▲', 'aria-hidden': true) if sorted_by?(column)
  end
end