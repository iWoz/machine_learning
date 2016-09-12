-- 盘面描述
SIDE_NULL = 0
SIDE_X = 1
SIDE_O = 2

-- 固定权值
FIXED_W0 = 0 -- 常数权重
FIXED_W1 = 1 -- 己方三连数权重
FIXED_W2 = 1 -- 对方三连数权重
FIXED_W3 = 1 -- 己方二连数权重
FIXED_W4 = 1 -- 对手二连数权重

-- 胜负平评分
VALUE_WINED = 100
VALUE_LOST = -100
VALUE_DRAW = 0

-- 更新步伐
UPDATE_STEP = 1

-- 终局状态
SIDE_DRAW = -1
SIDE_ING = 0
SIDE_X_WIN = 2
SIDE_O_WIN = 3
