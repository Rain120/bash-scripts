#### 参考

```sh
-e filename: 如果 filename 存在, 则为真
-d filename: 如果 filename 为目录, 则为真
# 绝对目录
-f filename: 如果 filename 为常规文件, 则为真
-L filename: 如果 filename 为符号链接, 则为真
-r filename: 如果 filename 可读, 则为真
-w filename: 如果 filename 可写, 则为真
-x filename: 如果 filename 可执行, 则为真
-s filename: 如果文件长度不为0, 则为真
-h filename: 如果文件是软链接, 则为真
filename1 -nt filename2: 如果 filename1比 filename2新, 则为真。
filename1 -ot filename2: 如果 filename1比 filename2旧, 则为真。
-eq 等于
-ne 不等于
-gt 大于
-ge 大于等于
-lt 小于
-le 小于等于
! 非
```
