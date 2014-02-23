class Game

	def initialize (n)

		@n = n

		@board = Array.new(@n) { Array.new(@n)}

		@playerMoves = Array.new(2) {Array.new} #2 = white, 0 = black

		@moveTable = Array.new(@n) {Array.new(@n) {Array.new(2) {Array.new}}}




		@board[3][3] = 1
		@board[4][4] = 1
		@board[4][3] = 0
		@board[3][4] = 0

		# @board[3][3] = 1
		# @board[4][4] = 1
		# @board[4][3] = -1
		# @board[3][4] = -1


		# places TO which white/black can move FROM index [i,j]
		# 1 for white 0 for black

		@moveTable[3][3][1] << [3,5] << [5,3]
		@moveTable[4][4][1] << [2,4] << [4,2]
		@moveTable[3][4][0] << [3,2] << [5,4]
		@moveTable[4][3][0] << [2,3] << [4,5]

		@moveTable[5][3][1] << [3,3]
		@moveTable[3][5][1] << [3,3]
		@moveTable[2][4][1] << [4,4]
		@moveTable[4][2][1] << [4,4]

		@moveTable[3][2][0] << [3,4]
		@moveTable[5][4][0] << [3,4]
		@moveTable[2][3][0] << [4,3]
		@moveTable[4][5][0] << [4,3]



		@playerMoves[1] << [3,5] << [5,3] << [2,4] << [4,2]

		@playerMoves[0] << [2,3] << [4,5] << [3,2] << [5,4]


	end

	def isDone
		@playerMoves[0] == [] && @playerMoves[1] == []
	end

	def getMoves (color)

		p @playerMoves[color]
		@playerMoves[color]
	end

	def getWinner
		bCount = 0
		wCount = 0

		for i in (0..7)
			for j in (0..7)
				if @board[i][j] == 1
					bCount = bCount + 1
				else
					wCount = wCount + 1
				end
			end
		end

		puts bCount
		puts wCount

		if bCount > wCount
			puts "Black Wins!"
		elsif wCount > bCount
			puts "White Wins!"
		else
			puts "Tie!"
		end

	end

	def makeMove (color)
		if @playerMoves[color] != []
			move = @playerMoves[color].sample
			update(move[0],move[1],color)
		end
	end

	def getMovesOther
		#@board[i][j] = Piece.new(color)

		#update(i,j,color)


		moveList = Array.new


		moveList[0] = Array.new
		moveList[2] = Array.new

		directions = [[0,-1],[-1,-1],[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1]]

		for x in 0..@n-1
			for y in 0..@n-1
				tmpx = x
				tmpy = y
				if @board[x][y] != nil
					color = @board[x][y].color
					directions.each do |dx, dy|
						x += dx
						y += dy

						if (@board[x][y] != nil && @board[x][y].color == -color)
							while (isInbounds(x,y) && @board[x][y] != nil && @board[x][y].color == -color)
								x += dx
								y += dy
							end

							if (isInbounds(x,y) && @board[x][y] == nil)
								moveList[color+1] << [x,y]
							end
						end



						x = tmpx
						y = tmpy
					end

				end
				x = tmpx
				y = tmpy
			end
		end

		puts "black moves:"
		p moveList[0].uniq
		puts "white moves:"
		p moveList[2].uniq

	end

	def printMoves(color)
		if color == 1
			player = "white"
		else
			player = "black"
		end
		print player + " moves: "
		@playerMoves[color].each do |x, y|
			print [x,y]
			print ": "
			p @moveTable[x][y][color]
			puts

		end
	end

	def update(i, j, player)

		list = Array.new

		list << [i,j]


		enemy = 1
		if (player == 1)
			enemy = 0
		end

		@playerMoves[player].delete([i,j])
		@playerMoves[enemy].delete([i,j])

		@board[i][j] = player



		@moveTable[i][j][player].each do |x, y|
			@moveTable[x][y][player].delete([i,j])


			dx = i - x
			dy = j - y

			max = [dx.abs,dy.abs].max

			dx /= max
			dy /= max


			x += dx
			y += dy

			while (x != i || y != j)
				list << [x,y]

				@moveTable[x][y][enemy].each do |a, b|
					@moveTable[a][b][enemy].delete([x,y])
					if (@moveTable[a][b][enemy] == [])
						@playerMoves[enemy].delete([a,b])
					end
				end
				@moveTable[x][y][enemy] = Array.new
				@board[x][y] = player
				x += dx
				y += dy
			end
		end

		@moveTable[i][j][player] = Array.new 
		@moveTable[i][j][enemy] = Array.new


		list.each do |x, y|
			tmpx = x
			tmpy = y

			#go in each direction (while not player) until you reach a player or nil
				#if nil, add location to playermoves etc

				#if player, nothing



			#go in each direction (while player) until you reach an enemy or a nil

				#if enemy, go in opposite direction until you reach an enemy or nil
					#if nil, add that location to enemy's move

				#if nil, nothing



			directions = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]


			directions.each do |dx, dy|

				x += dx
				y += dy

				while (isInbounds(x,y) && @board[x][y] == player)
					x += dx
					y += dy
				end

				if (isInbounds(x,y) && @board[x][y] == enemy)


					locx = x
					locy = y


					x = tmpx
					y = tmpy


					x -= dx
					y -= dy

					while (isInbounds(x,y) && @board[x][y] == player)
						x -= dx
						y -= dy
					end

					if (isInbounds(x,y) && @board[x][y] == nil)
						if (@moveTable[x][y][enemy] == [])
							@playerMoves[enemy] << [x,y]
						end
						@moveTable[locx][locy][enemy] << [x,y]
						@moveTable[x][y][enemy] << [locx,locy]
					end
				end

				x = tmpx
				y = tmpy


				########################################


				x += dx
				y += dy

				while (isInbounds(x,y) && @board[x][y] == enemy)
					x += dx
					y += dy
				end

				if (isInbounds(x,y) && @board[x][y] == player)

					locx = x
					locy = y

					x = tmpx
					y = tmpy

					x -= dx
					y -= dy

					while (isInbounds(x,y) && @board[x][y] == enemy)
						x -= dx
						y -= dy
					end

					if (isInbounds(x,y) && @board[x][y] == nil)
						@moveTable[locx][locy][player].delete([x,y])
						@moveTable[x][y][player].delete([locx,locy])
						if @moveTable[x][y][player] == []
							@playerMoves[player].delete([x,y])
						end

						# if ((tmpx != x + dx) && (tmpy != y + dy))
						# 	if (@moveTable[x][y][player] == [])
						# 		@playerMoves[player] << [x,y]
						# 	end
						# 	@moveTable[tmpx][tmpy][player] << [x,y]
						# 	@moveTable[x][y][player] << [tmpx,tmpy]
						# end
					end
					# if (@moveTable[x][y][player] == [])
					# 	@playerMoves[player] << [x,y]
					# end
					# @moveTable[tmpx][tmpy][player] << [x,y]
					# @moveTable[x][y][player] << [tmpx,tmpy]
				elsif (isInbounds(x,y) && @board[x][y] == nil && (tmpx+dx != x || tmpy+dy != y))
					if @moveTable[x][y][player] == []
						@playerMoves[player] << [x,y]
					end
					@moveTable[tmpx][tmpy][player] << [x,y]
					@moveTable[x][y][player] << [tmpx,tmpy]
				end
					

				x = tmpx
				y = tmpy

			end


		end




		# enemy = 1

		# if (player == 1)
		# 	enemy = 0
		# end

		# list = Array.new

		# @board[i][j] = player

		# #list << [i][j]

		# @playerMoves[0].delete([i,j])
		# @playerMoves[1].delete([i,j])

		# @moveTable[i][j][enemy].each do |x, y|
		# 	@moveTable[x][y][enemy].delete([i,j])

		# 	tmpi = i
		# 	tmpj = j




		# 	#add more moves ??
			
		# 	di = tmpi - x
		# 	dj = tmpj - y

		# 	max = [di.abs,dj.abs].max

		# 	di /= max
		# 	dj /= max

		# 	tmpi += di
		# 	tmpj += dj

		# 	#go in direction [di,dj] until you reach a nil or an enemy piece or the end of the board



		# 	while (isInbounds(tmpi,tmpj) && @board[tmpi][tmpj] == player)
		# 		tmpi += di
		# 		tmpj += dj
		# 	end 

		# 	if (isInbounds(tmpi,tmpj) && @board[tmpi][tmpj] == nil)

		# 		# tmpi = x
		# 		# tmpj = y

		# 		# while (tmpi != i || tmpj != j)
		# 		# 	@moveTable[tmpi][tmpj][enemy] << [locx,locy]

		# 		# 	tmpi += di
		# 		# 	tmpj += dj
		# 		# end

		# 		if (@moveTable[tmpi][tmpj][enemy] == nil)
		# 			@playerMoves[enemy] << [x,y]
		# 		end
		# 		@moveTable[tmpi][tmpj][enemy] << [x,y]

		# 		@moveTable[x][y][enemy] << [tmpi,tmpj]
		# 	end
		# end

		# @moveTable[i][j][enemy] = Array.new




		# @moveTable[i][j][player].each do |x, y|


		# 	#add enemy moves for each of these squares!

		# 	@moveTable[x][y][player].delete([i,j])

		# 	tmpi = i
		# 	tmpj = j

		# 	# list << [x,y]

		# 	dx = tmpi - x
		# 	dy = tmpj - y

		# 	max = [dy.abs,dx.abs].max

		# 	dx /= max
		# 	dy /= max

		# 	x += dx
		# 	y += dy


		# 	# while (isInbounds(x,y) && @board[x][y] == player)

		# 	# 	x += dx
		# 	# 	y += dy
		# 	# end


		# 	# x += dx
		# 	# y += dy

		# 	while (x != i || y != j)
		# 		list << [x,y]

		# 		@board[x][y] = player

		# 		x += dx
		# 		y += dy
		# 	end

		# end

		# @moveTable[i][j][player] = Array.new

		



		# list.each do |x, y|

		# 	#player: no moves added, some removed

		# 	#enemy: some moves added, none removed


		# 	@moveTable[x][y][player].each do |a, b|
		# 		dx = a - x
		# 		dy = b - y

		# 		max = [dy.abs,dx.abs].max

		# 		dx /= max
		# 		dy /= max		

		# 		x += dx
		# 		y += dy

		# 		while (!(@x == a && y == b) && @board[x][y] == enemy)
		# 			x += dx
		# 		end
		# 	end
		# end



		# # list = Array.new

		# # @board[i][j] = Piece.new(color)

		# # list << [i,j]

		# # player = @playerList[color+1]
		# # enemy = @playerList[-color+1]

		# # player.moves.delete([i,j])
		# # enemy.moves.delete([i,j])
		# 			y += dy
		# 		end

		# 		if (@board[x][y] == player)

		# 		end
		# 	end


		# 	@moveTable[x][y][enemy].each do |a, b|
		# 	end


		# player.moveTable[i][j].each do |x, y|

		# 	dx = i - x
		# 	dy = j - y
			
		# 	if (dy.abs > dx.abs)
		# 		max = dy.abs
		# 	else
		# 		max = dx.abs
		# 	end

		# 	dx /= max
		# 	dy /= max

		# 	x += dx
		# 	y += dy
		# 	while (x != i || y != j)
		# 		list << [x,y]

		# 		moves = @board[x][y].moves

		# 		moves.each do |i, j|
		# 			enemy.moveTable[i][j].delete([x,y])
		# 			enemy.moves.delete([i,j])
		# 		end

		# 		@board[x][y] = Piece.new(color)
		# 		x += dx
		# 		y += dy
		# 	end
		# end




		# directions = [[0,-1],[-1,-1],[-1,0],[-1,1]]

		# list.each do |x, y|
		# 	#p [x,y]
		# 	directions.each do |dx, dy|
		# 		done = false

		# 		tmpx = x
		# 		tmpy = y

		# 		x += dx
		# 		y += dy

		# 		p [dx,dy]

		# 		while (isInbounds(x,y) && @board[x][y] != nil && @board[x][y].color == -color)
		# 			x += dx
		# 			y += dy


		# 		end


		# 		if (isInbounds(x,y))
		# 			if (!player.moveTable[x][y])
		# 				player.moveTable[x][y] = Array.new
		# 				player.moves << [x,y]
		# 			end
		# 			player.moveTable[x][y] << [tmpx,tmpy]
		# 			@board[tmpx][tmpy].moves << [x,y]
		# 		end

		# 		x = tmpx
		# 		y = tmpy

		# 		x -= dx
		# 		y -= dy

		# 		while (isInbounds(x,y) && @board[x][y] != nil && @board[x][y].color == -color)
		# 			x -= dx
		# 			y -= dy
		# 		end				

		# 		if (isInbounds(x,y))
		# 			if (!player.moveTable[x][y])
		# 				player.moveTable[x][y] = Array.new
		# 				player.moves << [x,y]
		# 			end
		# 			player.moveTable[x][y] << [tmpx,tmpy]
		# 			@board[tmpx][tmpy].moves << [x,y]
		# 		end





		# 		x = tmpx
		# 		y = tmpy

		# 		x += dx
		# 		y += dy


		# 		while (isInbounds(x,y) && !done)

		# 			if (@board[x][y] == nil)

		# 				loc = [x,y]

		# 				x = tmpx
		# 				y = tmpy

		# 				x -= dx
		# 				y -= dy

		# 				while (isInbounds(x,y) && @board[x][y] != nil)

		# 					if (@board[x][y].color == -color)
		# 						if enemy.moveTable[loc[0]][loc[1]] == nil
		# 							enemy.moveTable[loc[0]][loc[1]] = Array.new
		# 							enemy.moves << [loc[0],loc[1]]
		# 						end
		# 						enemy.moveTable[loc[0]][loc[1]] << [x,y]
		# 						@board[x][y].moves << [loc[0],loc[1]]
		# 						break
		# 					end

		# 					x -= dx
		# 					y -= dy

		# 				end
		# 				done = true


		# 			elsif (@board[x][y].color == -color)
		# 				loc = [x,y]

		# 				x = tmpx
		# 				y = tmpy

		# 				x -= dx
		# 				y -= dy

		# 				while (isInbounds(x,y))

		# 					if (@board[x][y] == nil)
		# 						if enemy.moveTable[x][y] == nil
		# 							enemy.moveTable[x][y] == Array.new
		# 							enemy.moves << [x,y]
		# 						end								
		# 						enemy.moveTable[x][y] << [loc[0],loc[1]]
		# 						@board[loc[0]][loc[1]].moves << [x,y]
		# 						break
		# 					end

		# 					x -= dx
		# 					y -= dy
		# 				end
		# 				done = true
		# 			end

		# 			x += dx
		# 			y += dy
		# 		end
		# 	end
		# end


		# player.moveTable[i][j] = nil
		# enemy.moveTable[i][j] = nil

	end

	def isInbounds (x,y)
		0 <= x && x < @n && 0 <= y && y < @n
	end



	def printBoard
		for i in 0..@n-1
			for j in 0..@n-1
				if @board[i][j] == nil
					print '[ ]'
				elsif @board[i][j] == 1
					print " W "
				else
					print " B "
				end
			end
			puts
		end
	end

	def info
		puts "black moves: #{@playerMoves[0]}"
		puts "white moves: #{@playerMoves[1]}"


	end
end

# class Player
# 	attr_accessor :moves, :moveTable

# 	def initialize (n)
# 		@moves = Array.new
# 		@moveTable = Array.new (n) {Array.new (n)}
# 	end
# end

# class Square

# 	attr_accessor :moves, :color

# 	def initialize (color, moves)
# 		@color = color
# 		@moves = moves
# 	end
# end

class Move
	attr_accessor :fromList, :toList

	def initialize (fromList, toList)
		@fromList = fromList
		@toList = toList
	end

end

def run(color)#, depth, time1, time2)
	if color == 'W'
		myColor = 1
		enemyColor = 0
	else
		myColor = 0
		enemyColor = 1
	end

	game = Game.new(8)


	while (true)
		game.makeMove(0)

		# game.printBoard

		# game.info

		if (game.isDone)
			break
		end

		# game.printMoves(0)
		# game.printMoves(1)

		game.makeMove(1)

		# game.printBoard

		# game.info

		if (game.isDone)
			break
		end

		# game.printMoves(0)
		# game.printMoves(1)


	end	

	game.getWinner


	#game.update(4,2,1)

	#game.getMovesOther

	# game.info



	# if player == 1
	# 	while(true)
	# 		game.update(gets.split)
	# 		game.makeMove
	# 	end
	# else
	# 	while(true)
	# 		game.makeMove
	# 		game.update(gets.split)
	# 	end
	# end

end

#line = gets.split
run(gets.chomp)#[1]), line[2], line[3], line[4])