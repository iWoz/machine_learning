require "const"

-- 盘面状态函数
function getBoardParams(board, side)
	local side_x_1 = 0
	local side_x_2 = 0
	local side_o_1 = 0
	local side_o_2 = 0
	local side_null = 0

	local function account(dic)
		if dic[SIDE_X] == 3 then
			side_x_1 = side_x_1 + 1
		elseif dic[SIDE_O] == 3 then
			side_o_1 = side_o_1 + 1 
		elseif dic[SIDE_X] == 2 and dic[SIDE_O] == 0 then
			side_x_2 = side_x_2 + 1
		elseif dic[SIDE_O] == 2 and dic[SIDE_X] == 0 then
			side_o_2 = side_o_2 + 1
		end
		side_null = side_null + dic[SIDE_NULL]
	end

	-- 统计每一行
	for i=1,3 do
		local dic = {[SIDE_X]=0, [SIDE_O]=0, [SIDE_NULL]=0}
		for j=1,3 do
			dic[board[i][j]] = dic[board[i][j]] + 1
		end
		account(dic)
	end
	-- 统计每一列
	for i=1,3 do
		local dic = {[SIDE_X]=0, [SIDE_O]=0, [SIDE_NULL]=0}
		for j=1,3 do
			dic[board[j][i]] = dic[board[j][i]] + 1
		end
		account(dic)
	end
	-- 统计对角线
	local diagonalPair = 
	{
		{{1,1}, {2,2}, {3,3}},
		{{1,3}, {2,2}, {3,1}},
	}
	for _,pairList in ipairs(diagonalPair) do
		local dic = {[SIDE_X]=0, [SIDE_O]=0, [SIDE_NULL]=0}
		for _,pair in ipairs(pairList) do
			local bi = board[pair[1]][pair[2]]
			dic[bi] = dic[bi] + 1
		end
		account(dic)
	end

	if side == SIDE_X then
		return {side_x_1, side_o_1, side_x_2, side_o_2}, side_null
	else
		return {side_o_1, side_x_1, side_o_2, side_x_2}, side_null
	end
end

-- 打印盘面
function printBoard(board)
	local log = ""
	for i=1,3 do
		for j=1,3 do
			log = log .. board[i][j]..","
		end
		log = log .. "\n"
	end
	print(log)
end

-- 表的混淆
function shuffleTable(t, startIndex, endIndex)
    startIndex = startIndex or 1
    endIndex = endIndex or #t
    for i = endIndex, startIndex+1, -1 do
        local j = math.random(startIndex, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end
