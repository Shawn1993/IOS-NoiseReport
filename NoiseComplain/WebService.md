##WebService模块说明

封装了 *NSURLSession* 的功能, 按照~~我觉得~~更方便的方式封装请求参数<br>
目前仅使用了 **dataTask** 类型的请求, 根据需要刻意再增加 **upload/download** 类型的请求

###使用方式
- ####获取 *NCPWebRequest* 实例
	在发送请求前的操作, 都是对 *NCPWebRequest* 实例的操作<br>
	服务器地址用**常量**提供, 只需要提供 *Servlet* 页面的名称即可 **(必须!)**<br>
	使用 **[NCPWebRequest requestWithPage:\<Servlet\>]** 方法获取实例<br>
	
- ####组织**请求参数**
	参数是有类型的


- ####发送请求并**处理应答**

###请求格式说明
