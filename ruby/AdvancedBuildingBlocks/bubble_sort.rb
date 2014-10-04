def bubble_sort(items)
  unsorted_end = items.length
  while unsorted_end > 1
    last_swap = 0
    for i in 1.upto(unsorted_end - 1)
      if items[i - 1] > items[i]
        items[i - 1], items[i] = items[i], items[i - 1]
        last_swap = i
      end
    end
    unsorted_end = last_swap
  end
  items
end

def bubble_sort_by(items)
  unsorted_end = items.length
  while unsorted_end > 1
    last_swap = 0
    for i in 1.upto(unsorted_end - 1)
      if yield(items[i - 1], items[i]) < 0
        items[i - 1], items[i] = items[i], items[i - 1]
        last_swap = i
      end
    end
    unsorted_end = last_swap
  end
  items
end