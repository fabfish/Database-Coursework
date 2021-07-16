use lab1;

# 实体完整性
# 插入书籍时主码为空
#insert into Book value(null, '数据库系统实现', 'Ullman', 59.0, 1);

# 参照完整性
# 被参照表缺失所引用的项
#insert into Borrow value('b5', 'r100',  '2021-03-12', '2021-04-07');

# 用户自定义完整性
# status 不是 0 或 1
#insert into Book value('b1', '数据库系统实现', 'Ullman', 59.0, 2);