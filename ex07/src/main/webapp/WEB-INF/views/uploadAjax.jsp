<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<!-- jQeury 라이브러리 경로설정  -->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transcitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>Upload with Ajax</h1>
	



<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 100px;
}
</style>

<style>
.bigPictureWrapper {
  position: absolute;
  display: none;
  justify-content: center;
  align-items: center;
  top:0%;
  width:100%;
  height:100%;
  background-color: gray; 
  z-index: 100;
}

.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}
</style>

<!-- 첨부파일영역 처리 --> <!-- 실제 원본이미지 보여주는 영역 HTML  -->
<div class='bigPictureWrapper'>
  <div class='bigPicture'>
  </div>
</div>


<div class='uploadDiv'>
		<input type='file' name='uploadFile' multiple>
	</div>

	<div class='uploadResult'>  <!-- 첨부파일 이름을 목록으로 처리 -->
		<ul>

		</ul>
	</div>


	 <button id='uploadBtn'>Upload</button> 
	
	<!-- <script>처리로 첨부파일 설정 -->
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"
		integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
		crossorigin="anonymous"></script>
		

<script>

function showImage(fileCallPath){	//실제 원본이미지 보여주는 영역
	
	//alert(fileCallPath);
	
	 $(".bigPictureWrapper").css("display","flex").show(); //화면의 정중앙에 배치 
	  
	 $(".bigPicture")
	  .html("<img src='/display?fileName="+fileCallPath+"'>")
	  .animate({width:'100%', height: '100%'}, 1000); //지정된사긴동안 화면에서 열리는 효과 
	  
}


$(".bigPictureWrapper").on("click", function(e){
	  $(".bigPicture").animate({width:'0%', height: '0%'}, 1000);
	  setTimeout(() => {
	    $(this).hide();
	  }, 1000);
	}); //다시 섬네일 원본이미지 클릭시 원본이미지가 화면중앙으로 점차 사라지는 코드


$(".uploadResult").on("click","span", function(e){ //<span>태그이용하여 처리. 첨부파일의 업로드후에 생성되기 때문에 이벤트위임 방식 
		   
	  var targetFile = $(this).data("file");
	  var type = $(this).data("type");
	  console.log(targetFile);
		  
	  $.ajax({
	    url: '/deleteFile',
	    data: {fileName: targetFile, type:type}, //Ajax를 이용하여 파일의 경로,이름,파일종류 전송 
	    dataType:'text',
	    type: 'POST',
	      success: function(result){
	       alert(result);
	    }
  }); //$.ajax		  
  
}); //첨부파일 삭제 시 x표시에 대한 이벤트처리 
	
	

var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
var maxSize = 5242880; //5MB
		

	function checkExtension(fileName, fileSize) {

		if (fileSize >= maxSize) { //첨부파일 사이즈제한 
			alert("파일 사이즈 초과");
			return false;
		}

		if (regex.test(fileName)) { //첨부파일 확장자제한 
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}
	
	
	var cloneObj = $(".uploadDiv").clone();  //첨부파일부분 초기화 
	
	$("#uploadBtn").on("click", function(e){

		 var formData = new FormData();   //jQuery로 파일업로드할때 FormData객체 생성 
		
		 var inputFile = $("input[name='uploadFile']");
		
		 var files = inputFile[0].files;
		
		 console.log(files);
		 
		 //add filedate to formdata
		 for(var i = 0; i < files.length; i++){
		
			 if (!checkExtension(files[i].name, files[i].size)) { //첨부파일 사이즈/확장자 제한 조건문 삽입 
					return false;
				}
			 
		 formData.append("uploadFile", files[i]);
		 
		 }
		 
		 
		 $.ajax({
			 url: '/uploadAjaxAction',
			 processData: false, 
			 contentType: false,
			 data: formData,  //컨트롤러 url로 formData 전송 
			 type: 'POST',
			 dataType : 'json', //결과데이터 json으로 반환 

			 success: function(result){
				 console.log(result);			 
				 
					showUploadedFile(result); //첨부파일목록보여주는 함수 호출 

					
				 $(".uploadDiv").html(cloneObj.html()); //첨부파일 초기화 코드
			 }
			 }); //$.ajax
			 
		 });
	
	 
	var uploadResult = $(".uploadResult ul");

	function showUploadedFile(uploadResultArr) {

		var str = "";

		$(uploadResultArr).each( function(i, obj) {

			if (!obj.image) {  //첨부파일목록을 보여주는 함수 (attach.png)
			
				var fileCallPath =  encodeURIComponent( 
						obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);
			
				//<span>태그를 이용하여 섬네일이나 파일아이콘 옆에 x표시. 'data-file', 'data-tyoe'속성 추가 
			    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/"); 
			        
		          //str += "<li><a href='/download?fileName="+fileCallPath+"'>" 
		        		 // +"<img src='/resources/img/attach.png'>"+obj.fileName+"</a></li>"  //<a>태그 추가 
			    str += "<li><div><a href='/download?fileName="+fileCallPath+"'>"+
		           "<img src='/resources/img/attach.png'>"+obj.fileName+"</a>"+
		           "<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span>"+
		           "<div></li>"
		        		  
		        		  
			} else {
				//str += "<li>" + obj.fileName + "</li>";
				
				//URL호출에 적합한 문자열로 인코딩처리 
				 var fileCallPath =  encodeURIComponent( 
						 obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
		         
				  var originPath = obj.uploadPath+ "/"+obj.uuid +"_"+obj.fileName;  //첨부파일의 경우 업로드된 경로와 UUID가 붙은파일이름이 필요하므로 origin변수를 통해 하나의 문자열로 생성 
			       
			       originPath = originPath.replace(new RegExp(/\\/g),"/"); 
			       
			       str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\">"+
		              "<img src='display?fileName="+fileCallPath+"'></a>"+
		              "<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span>"+
		              "<li>";
			}
		});
		uploadResult.append(str);
	}		 
			
</script>	
	
	
</body>
</html>
	