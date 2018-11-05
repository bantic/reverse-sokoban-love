function love.config(t)
  t.console = true
end

function love.load()
  target = {
    x = 50,
    y = 50,
    w = 100,
    h = 100
  }
  pieces = {
    {
      x = 0,
      y = 0,
      w = 25,
      h = 25,
      inTarget = false
    },
    {
      x = 250,
      y = 250,
      w = 25,
      h = 25,
      inTarget = false
    },
    {
      x = 350,
      y = 350,
      w = 25,
      h = 25,
      inTarget = false
    },
    {
      x = 50,
      y = 50,
      w = 25,
      h = 25,
      inTarget = false
    },
    {
      x = -50,
      y = -50,
      w = 25,
      h = 25,
      inTarget = false
    }
  }
end

function love.update(dt)
end

function love.draw()
  love.graphics.rectangle("line", target.x, target.y, target.w, target.h)
  for i,piece in ipairs(pieces) do
    love.graphics.rectangle("line", piece.x, piece.y, piece.w, piece.h)
  end
end

function isAnyPieceAtPos(pos)
  for i,piece in ipairs(pieces) do
    if piece.x == pos.x and piece.y == pos.y then
      return true
    end
  end
  return false
end

function canMove(dir, piece)
  if not piece.inTarget then
    print("can! move piece dir" .. dir)
    return true
  end

  local nextPos = getNextPos(dir, piece)
  if not isPosInTarget(nextPos) then
    print("new pos is not in target!!")
    return false
  end
  if isAnyPieceAtPos(nextPos) then
    print("there is another piece at the pos")
    return false
  end

  return true
end

function isPosInTarget(pos)
  return pos.x >= target.x and pos.y >= target.y
         and pos.x < (target.x+target.w)
         and pos.y < (target.y+target.h)
end

function getNextPos(dir, piece)
  local newX = piece.x
  local newY = piece.y
  if dir == "up" then
    newY = piece.y - piece.h
  elseif dir == "down" then
    newY = piece.y + piece.h
  elseif dir == "left" then
    newX = piece.x - piece.w
  elseif dir == "right" then
    newX = piece.x + piece.w
    print("dir == right, newX:"..newX)
  end

  return {
    x = newX,
    y = newY
  }
end

function movePiece(piece, dir)
  if not canMove(dir, piece) then
    return
  end
  local nextPos = getNextPos(dir, piece)
  print("updating piece ti "..nextPos.x..","..nextPos.y)
  piece.x = nextPos.x
  piece.y = nextPos.y
  piece.inTarget = isPosInTarget(piece)
  return piece
end

function love.keypressed(key)
  for i,piece in ipairs(pieces) do
    print("moving piece "..i)
    local updatedPiece = movePiece(piece, key)
    if updatedPiece then
      pieces[i] = updatedPiece
    end
  end
end