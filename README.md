# ZXCodeCreater
根据通用模板快速生成目标文件夹及文件

思路：真正的快速生成代码文件，其实就是将模板的类名修改；


需要说明的几点：  
1. dmg软件包在Application目录；  
2. 使用之前，需要你们首先为自己定制一套通用模板文件，其中需要注意的是，无论是文件夹还是类名，前缀都要保持一致；这样才能替换成功；  
3. 使用之时，直接select选择模板通用文件所在位置，如需测试，可以定位到我准备的ZXCodeCreaterTest目录，然后Class Prefix In Module就是模型文件中的类前缀，如果你使用的是我准备的ZXCodeCreaterTest，那么统一前缀就是ZXCodeCreaterTest，后面的Target Class Prefix你随意填写就好；
