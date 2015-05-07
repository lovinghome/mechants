<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta charset="UTF-8">
		<title>科技新城招商管理平台</title>
		<link rel="stylesheet" type="text/css" href="/css/easyUI/easyui.css">
		<link rel="stylesheet" type="text/css" href="/css/easyUI/icon.css">
		<link rel="stylesheet" type="text/css" href="/css/easyUI/demo.css">
		<script type="text/javascript" src="/js/easyUI/jquery.js"></script>
		<script type="text/javascript" src="/js/easyUI/jquery.easyui.min.js"></script>
		<script type="text/javascript" src="/js/datefomate.js"></script>
		<script type="text/javascript" src="/js/easyUI/datagrid-groupview.js"></script>
		<script type="text/javascript">
	$(function(){
		initdatagrid();
		initdlg();
		initsearch();
		$.extend($.messager.defaults,{
    		ok:"确定",
    		cancel:"取消"
		});
	});
	function reload(){
		$('#dg').datagrid('load',{url:'/group/ne/indexSubmit'});
	}
	
	function search(){
		$('#search').window('open');
	}
	
	function initsearch(){
		$('#ss').searchbox( {
		searcher : function(value, name) { 
		$('#dg').datagrid('load', {
			"searchKey" : name,
			"searchValue" : value
		});
		},
		menu : '#mm',
		prompt : '请输入项目编号或项目名称'
		});

		$('#search').window( {
			resizable:false,
			draggable:false,
			width: 300,  
    		height: 100,
			minimizable:false,
			maximizable:false,
			title:'搜索',
			closed : true
		});
	}
	function initdlg(){
		$('#dlg').dialog({  
    		title: '洽谈信息',  
   	 		width: 600,  
    		height: 400,  
    		closed: true,  
    		cache: false,  
    		modal: true ,
    		
		}); 
		  
	}
	function initdatagrid(){
		$("#dg").datagrid({
			url:'/group/ne/loadSubmit',
			title:'洽谈信息列表',
			pagination:true,
			pageSize : 10,
			rownumbers : true,
			singleSelect:true,
			align:'center',
			pageList:[5,10,20,50,100],
			fit : true,// 自动大小
			columns:[[
				{field:'cProCode',title:'项目编号',width:100,sortable:true},
				{field:'cng_Address',title:'洽谈地点',width:100},
				{field:'cng_Advice',title:'洽谈引进建议',width:100},
				{field:'cng_Analysis',title:'洽谈分析',width:100},
				{field:'cng_Content',title:'洽谈内容',width:100},
				{field:'cng_Element',title:'吸引企业入驻因素',width:100},
				{field:'cng_Person',title:'参与人员',width:100},
				{field:'cng_Problem',title:'待解决问题',width:100},
				{field:'cng_Require',title:'项目方要求',width:100},
				{field:'cng_Result',title:'洽谈结果',width:100},
				{field:'cng_Works',title:'工作安排',width:100},
				{field:'csummarize',title:'小  结',width:100},
				{field:'state',title:'状 态',width:100,formatter: function(value,row,index){
					if(value == '不通过') {
					var str='\'未通过原因\',\''+row.reason+'\',\'info\'';
					value+="(<a href=javascript:void(0) onclick=\"$.messager.alert("+str+ ")\">原因查看</a>)";
					}
					return value;
				}},
				{field:'coperator',title:'操作员',width:100},
				{field:'cdate',title:'研判日期',width:100,sortable:'true',formatter: function(value,row,index){
				return dateFormat(value.time,"isoDate")
				}},
			]],
			groupField:'cProName',  
    		view: groupview,  
    		groupFormatter:function(value, rows){  
       		return value + ' - 共' + rows.length + '条洽谈记录';  
    		} ,
			toolbar:[{  
            text:'编辑',  
            iconCls:'icon-edit',  
            handler:function(){  
                edit();  
            }  
        },'-',{  
            text:'删除',  
            iconCls:'icon-remove',  
            handler:function(){  
                deleteRow();  
            }  
        },'-',{  
            text:'导出excel',  
            iconCls:'icon-excel',  
            handler:function(){  
                exportExcel();  
            }  
        },'-',{  
          text:'查询',  
          iconCls:'icon-search',  
          handler:function(){  
              search();  
          }  
      },'-',{  
          text:'刷新',  
          iconCls:'icon-reload',  
          handler:function(){  
              reload();  
          }  
      },'-'], 
		})
	}
	var url;
	var type;
	var projectId;
	function upload(){
		if(projectId==null){$.messager.alert('提示',"请选择项目",'info');}
		else
		window.open("/group/upload/selectFile?projectId="+projectId+"&statustype=2","","location=no,width=800,height=300,top=400,left=300")
	}
	function edit(){
		var row = $('#dg').datagrid('getSelected');
		if (row) {
		$.post('/group/co/isEdit',{'cProCode':row.cProCode},function(data,status){
			var result=$.parseJSON(data);
			if(result.errorMsg == ''){
				$('#dlg').dialog('open').dialog('setTitle', '编辑研判信息');
				$('#cc').combobox({  
					url:'/group/co/loadEditProject?cProCode='+row.cProCode,
   				 	valueField:'id',  
  				  	textField:'cProName',
  				  	onSelect:function(rec){
  				  		projectId = rec.id
  				  	}  
				});
				$('#cc').attr('readonly','readonly');
				$('#fm').form('load', row);
				url = '/group/co/add?id=' + row.id+'&type=2';
			} else $.messager.alert('提示','不能执行此操作','info');
		})
			
		}else{
			$.messager.alert('提示',"请选择你要编辑的记录",'info');
		}
	}
	
	function exportExcel() {
	$.messager.progress( {
		text : '正在导出Excel. 请稍等...',
		interval:100
	});
	$.post('/group/ne/excelSubmit', {fileName:'negotiate.xls'}, function(data) {
		var data = $.parseJSON(data);// 将回调函数的json字符串转成一个对象
		if(data.status=="succeed"){
			var message="<div align='center'><a href="+data.filePath+">"+"下载"+"</a></div>";
			$.messager.progress('close');
			$.messager.alert("下载提示",message);
		}
			//javascript: window.location = 'getFile.php?p=' + data;
	});
	}
	function add(){
		$.post('/group/co/exsitProject','',function(data,status){
		var result=$.parseJSON(data);
		if(result.errorMsg=='') {
			$('#dlg').dialog('open').dialog('setTitle', '新建表单');
			$('#cc').combobox({  
					data:result.project,
   				 	valueField:'id',  
  				  	textField:'cProName'  
			}); 
			$('#fm').form('clear');
			url = '/group/co/add?type=1';
			}
		else $.messager.alert('提示',result.errorMsg,'info');
		});
		
		
		
	}
	
	function save(p) {
		$('#fm').form('submit', {
			url : url+'&p='+p,
			onSubmit : function() {
				return $(this).form('validate');
			},
			success : function(data) {
				var result = $.parseJSON(data);
				if (result.errorMsg) {
					$.messager.show( {
						title : '错误',
						msg : result.errorMsg
					});
				} else {
					$('#dlg').dialog('close'); // close the dialog
			$('#dg').datagrid('reload'); // reload the user data
		}
	}
		});
	}
	function deleteRow() {
		var row = $('#dg').datagrid('getSelected');
		if (row) {
			$.post('/group/co/isEdit',{'cProCode':row.cProCode},function(data,status){
				var result = $.parseJSON(data);
				if(result.errorMsg==''){
				$.messager.confirm('确认',
					'确定删除吗?', function(r) {
						if (r) {
							$.post('/group/co/deleteRow', {
								id : row.id
							}, function(result) {
								if (result.success) {
									$('#dg').datagrid('reload'); // reload the  data
								} else {
									$.messager.show( { // show error message
												title : '错误',
												msg : result.errorMsg
											});
								}
							}, 'json');
						}
					})
				}else{
				$.messager.alert('提示','不能执行此操作','info');
				}
			});
			
		}
		else $.messager.alert('提示',"请选择你要删除的记录",'info');
	}
	
	function up(p){
		save(p);
	}
	function persist(p){
		save(p);
	}
	</script>
	</head>
	<body>
	
		<div id="search" title="搜索" iconCls="icon-search" modal="true"
			style="background: #fafafa; width: 380px; height: 100px;">
			<div style="padding: 20px 20px 20px 20px;">
			<input id="ss"></input>
			<div id="mm" style="width: 120px">
				<div data-options="name:'cProCode',iconCls:'icon-ok'">
					项目编码
				</div>
				<div data-options="name:'cProName'">
					项目名称
				</div>
			</div>
			</div>
		</div>
		
		<table id="dg"></table>
		<div id="dlg" buttons="#dlg-buttons">
			<form id="fm" method="post">
				<div id="project" align="center">
					<label>
						项目名称
					</label>
					<input id="cc" name="projectId" required="true" missingMessage="该选项为必选项">
				</div>
				<div align="center">
					<label>
						参与人员
					</label>
					<input name="cng_Person">
					<label>
						洽谈地点
					</label>
					<input name="cng_Address">
					
				</div>
				<div align="center">
					<label>
						洽谈引进建议
					</label>
					<textarea rows="5" cols="50" name="cng_Advice"></textarea>
				</div>
				<div align="center">
					<label>
						项目方提出的要求
					</label>
					<textarea rows="5" cols="50" name="cng_Require"></textarea>
				</div>
				<div align="center">
					<label>
						洽谈分析
					</label>
					<textarea rows="5" cols="50" name="cng_Analysis"></textarea>
				</div>
				<div align="center">
					<label>
						洽谈内容
					</label>
					<textarea rows="5" cols="50" name="cng_Content"></textarea>
				</div>
				<div align="center">
					<label>
						吸引企业入驻因素
					</label>
					<textarea rows="5" cols="50" name="cng_Element"></textarea>
				</div>
				<div align="center">
					<label>
						待解决问题
					</label>
					<textarea rows="5" cols="50" name="cng_Problem"></textarea>
				</div>
				<div align="center">
					<label>
						洽谈结果
					</label>
					<textarea rows="5" cols="50" name="cng_Result"></textarea>
				</div>
				<div align="center">
					<label>
						工作安排
					</label>
					<textarea rows="5" cols="50" name="cng_Works"></textarea>
				</div>
				<div align="center">
					<label>
						小  结
					</label>
					<textarea rows="5" cols="50" name="csummarize"></textarea>
				</div>
				<div align="center">
					<div id="filename">	
					</div>
					<input type="button" value="上传附件" onclick="upload()">
				</div>
			</form>
		</div>
		<div id="dlg-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="up(1)">提交</a>
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="persist(0)">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick=javascript:$('#dlg').dialog('close');
>取消</a>
		</div>
	</body>
</html>