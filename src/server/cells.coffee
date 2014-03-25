if Cells.find().count() == 0
  for y in [0...GRID_HEIGHT]
    for x in [0...GRID_WIDTH]
      Cells.insert
        x: x
        y: y

