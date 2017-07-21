<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.suneasy.web.menuType.MenuGetType" %>
<%@ page import = "com.suneasy.basic.util.Tools" %>
<%@ include file="/config.jsp"%>
<%	
	response.setContentType("UTF-8");
	Rs rs=null;
	t_dao t_dao = new t_dao();
	String cid = Tools.RmNull(request.getParameter("cid"));
	String appuser = "";
	String headimg = "";
	String age = "";
	String tag = "";
	Ls ls_user = null;
	Ls ls_comment = null;
	int i = 0;
	String city1 = "";
	String city2 = "";
	String sex = "images/nv.png";
	String cy_img = "";
	String cy_nickname = "";
	
try {
	rs = t_dao.getRs("t_jieban","rid="+cid+"");
	t_html.set("t_info",rs);
	appuser = t_dao.getValue("t_jieban","rid="+cid+"","appuser");
	headimg = t_dao.getValue("t_user","c_userid='"+appuser+"'","pic_small");
	if(headimg.equals("")){
		headimg = "http://a.booea.cn:8181/userfiles/headimg.png";
	}else{
		headimg = "http://api.booea.cn:8181"+headimg;
	}
	
	age = t_dao.getValue("t_user","c_userid='"+appuser+"'","c_birthday").substring(0, 4);
	String currdate = Tools.getDate().substring(0, 4);
    age = Tools.isNumber(Tools.jian(currdate, age))+"";
	
	sex = Tools.RmNull(t_dao.getValue("t_user","c_userid='"+appuser+"'","c_sex"));
	if(sex.equals("男")){
		sex = "<p style=\"background-color:#30bcff;\"><img src=\"images/nan.png\" width=\"15\" height=\"15\">"+age+"</p>";
	}else{
		sex = "<p style=\"background-color:#ff96b3;\"><img src=\"images/nv.png\" width=\"15\" height=\"15\">"+age+"</p>";
	}
	
	
	tag = t_dao.getValue("t_jieban", "rid="+cid+"", "tag");
	int taglength = 0;
	if(!tag.equals("")){
		String[] strs = tag.split(",");
		tag = "";
		if(strs.length>4){
			taglength = 4;
		}else{
			taglength = strs.length;
		}
		for(int ii=0;ii<taglength;ii++){
			String tagpic_small = t_dao.getValue("t_tag", "c_code="+strs[ii]+"", "pic_small");
			tag += "<li><img src=\""+tagpic_small+"\"></li>";
		}
	}
	
	String images = t_dao.getValue("t_jieban", "rid="+cid+"", "contents");
	String imgs = "";
	String str2[] = {};
	if(!images.equals("")){
		str2 = images.split(","); 
		for (int p=0;p<str2.length;p++) {
			imgs += "<a style=\"width:24%;height:76px;overflow:hidden;\"><img src=\"http://api.booea.cn:8181"+str2[p]+"\" onload=\"this.style.marginTop = (parseInt(this.parentNode.style.height) - this.height)/2 + 'px'\"></a>";	
		}
	}
	
	//加入成员
	int cy_num = 0;
	i = 1;
	ls_user = t_dao.getLs("t_jieban_log", "c_id="+cid+" and c_companyid="+c_companyid+"");
	cy_num = t_dao.getNum("t_jieban_log", "c_id="+cid+" and c_companyid="+c_companyid+"");
	for(Rs item : ls_user.getItems()){
		cy_img = t_dao.getValue("t_user", "c_userid='"+item.get("appuser")+"'", "pic_small");
		if(cy_img.equals("")){
			cy_img = "http://a.booea.cn:8181/userfiles/headimg.png";
		}else{
			cy_img = "http://api.booea.cn:8181"+cy_img;
		}
		item.set("headimg",cy_img);
		i++;
	}
	
	//评论
	cy_img = "";
	ls_comment = t_dao.getLs("comment", "c_id="+cid+" and c_table='t_jieban'");
	for(Rs item : ls_comment.getItems()){
		cy_img = t_dao.getValue("t_user", "c_userid='"+item.get("userid")+"'", "pic_small");
		cy_nickname = t_dao.getValue("t_user", "c_userid='"+item.get("userid")+"'", "c_blognick");
		if(cy_img.equals("")){
			cy_img = "http://a.booea.cn:8181/userfiles/headimg.png";
		}else{
			cy_img = "http://api.booea.cn:8181"+cy_img;
		}
		item.set("headimg",cy_img);
		item.set("nickname",cy_nickname);
		i++;
	}
	
	city1 = t_dao.getValue("t_jieban", "rid="+cid+"", "start");
	city1 = t_dao.getValue("t_diqu", "c_code="+city1+"", "c_name");
	//目的地
	String destination = t_dao.getValue("t_jieban", "rid="+cid+"", "destination");
	String str3[]={};
	String des = "";
	if(!destination.equals("")){
		str3 = destination.split(","); 
		for (int p=0;p<str3.length;p++) {
			if(!str3[p].equals("")){
			des += "&mdash;&mdash;"+t_dao.getValue("t_diqu", "c_code="+str3[p]+"", "c_name");
			}
		}
	}
	
	t_html.set("nickname",t_dao.getValue("t_user","c_userid='"+appuser+"'","c_blognick"));
	t_html.set("headimg",headimg);
	t_html.set("age",age);
	t_html.set("tag",tag);
	t_html.set("imgs",imgs);
	t_html.set("ls_user",ls_user);
	t_html.set("ls_comment",ls_comment);
	t_html.set("cy_num",cy_num);
	t_html.set("city1",city1);
	t_html.set("city2",des);
	t_html.set("sex",sex);
	t_html.Render("/fenxiang/fenxiang.htm");
	
} catch (Exception e){
   System.out.println(" error Exception :" + e);
}finally
{
}
%>