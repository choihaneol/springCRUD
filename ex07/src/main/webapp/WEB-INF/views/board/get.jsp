<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> <!-- 현재 조회페이지에서 작성자와 현재 사용자의 정보가 같을경우만 수정/삭제 버튼 처리 활성화 -->
<%@include file="../includes/header.jsp"%>

<!-- register.jsp에서는 <form>태그를 이용해서 필요한 데이터를 전송
<input>이나 <textarea>태그의 name속성은 BoardVO 클래스의 변수와 일치시켜 줘야함.  -->

<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Board Read</h1>
  </div>
  <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">Board Read Page</div>
      <!-- /.panel-heading -->
      <div class="panel-body">

       
          <!-- 게시물벚호를 보여줄 수 있는 필드 추가 및 readonly지정  -->
          <div class="form-group">
            <label>Bno</label> <input class="form-control" name='bno'
            value='<c:out value="${board.bno }"/>' readonly="readonly">
          </div>
       
           <div class="form-group">
          <label>Title</label> <input class="form-control" name='title'
            value='<c:out value="${board.title }"/>' readonly="readonly">
        </div>

          <div class="form-group">
            <label>Text area</label>
            <textarea class="form-control" rows="3" name='content'
            readonly="readonly"><c:out value="${board.content }" /></textarea>
          </div>

          <div class="form-group">
          <label>Writer</label> <input class="form-control" name='writer'
            value='<c:out value="${board.writer }"/>' readonly="readonly">
        </div>
          
          <!-- <form>태그 삭제 및 수정/삭제 페이지로 이동하거나 원래의 페이지로 이동 할수 있는 버튼 및 이동링크 추가 -->
          <!-- <button data-oper='modify' class="btn btn-default"
          onclick="location.href='/board/modify?bno=<c:out value="${board.bno }"/>'">
          Modify</button>
          <button data-oper='list' class="btn btn-info" 
          onclick="location.href='/board/list'">
          List</button> -->
 
        <!-- <form> 처리  -->
        <!-- <button data-oper='modify' class="btn btn-default">Modify</button> -->
        <!-- 작성자와 사용자의 정보 비교하여 modify버튼 활성화 -->
         <sec:authentication property="principal" var="pinfo"/> <!-- 태그를 매번 이용하는것은 볼편하기 때문에 로그인과 관련된 정보인 principal은 아예 jsp내에서 pinfo라는 이름의 변수로 사용됨  --> -->

        <sec:authorize access="isAuthenticated()"> <!-- 인증받은 사용자만이 영향을 받기위해서 지정 -->

        <c:if test="${pinfo.username eq board.writer}"> <!-- 현재 사용자가 게시물의 작성자와 일치하는지 확인해서 Modify 버튼 활성화 -->
        
        <button data-oper='modify' class="btn btn-default">Modify</button>
        
        </c:if>
        </sec:authorize>
        
        
        <button data-oper='list' class="btn btn-info">List</button>
       
        <form id='operForm' action="/boad/modify" method="get">
        <input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>  
        <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>   <!-- 버튼을 클릭하면 <form>태그를 이용하는 방식에맞춰 데이터를 추가해서 이동하도록 함 -->
        <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
        <!-- 조회페이지에서 Criteria의 type,keyword 처리 -->
         <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
          <input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>
        </form>
        

      </div>
      <!--  end panel-body -->

    </div>
    <!--  end panel-body -->
  </div>
  <!-- end panel -->
</div>
<!-- /.row -->


<!-- 첨부파일 보여지는부분  -->
<div class='bigPictureWrapper'>
  <div class='bigPicture'> <!-- 원본이미지 보여지는부분 -->
  </div>
</div>

<style>
.uploadResult {
  width:100%;
  background-color: gray;
}
.uploadResult ul{
  display:flex;
  flex-flow: row;
  justify-content: center;
  align-items: center;
}
.uploadResult ul li {
  list-style: none;
  padding: 10px;
  align-content: center;
  text-align: center;
}
.uploadResult ul li img{
  width: 100px;
}
.uploadResult ul li span {
  color:white;
}
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
  background:rgba(255,255,255,0.5);
}
.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}

.bigPicture img {
  width:600px;
}
</style>


<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">Files</div>
      <!-- /.panel-heading -->
      <div class="panel-body">
        
        <div class='uploadResult'>  <!-- 첨부파일목록 보여지는 부분 -->
          <ul>
          </ul>
        </div>
      </div>
      <!--  end panel-body -->
    </div>
    <!--  end panel-body -->
  </div>
  <!-- end panel -->
</div>
<!-- /.row -->



<!-- 댓글목록 화면처리 -->
<div class='row'>

  <div class="col-lg-12">

    <!-- /.panel -->
    <div class="panel panel-default">
    <!-- <div class="panel-heading">
        <i class="fa fa-comments fa-fw"></i> Reply
      </div> -->
      
    <!-- 새로운댓글 버튼 -->
    <!--  <div class="panel-heading">
        <i class="fa fa-comments fa-fw"></i> Reply
        <button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>  
      </div>  --> 
      <!-- 로그인한 사람만 댓글버튼 활성화  -->   
       <div class="panel-heading">
        <i class="fa fa-comments fa-fw"></i> Reply
        <sec:authorize access="isAuthenticated()">
        <button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
        </sec:authorize>
      </div>     
      
      <!-- /.panel-heading -->
      <div class="panel-body">        
      
        <ul class="chat">
        </ul>
        </div> <!-- /.panel .chat-panel 추가 -->
        <div class="panel-footer">  <!-- 댓글페이지번호를 출력하는 로직은 showReplyPage() -->
        </div>
       <!-- start reply  -->
       <li class="left clearfix" data-rno='98'> <!-- clearfix : 네비게이션바가 float로 뭉개짐 방지 -->
       <div>
       <div class="header">
       <strong class="primary-front">user00</strong>
       <small class="pull-right text-muted">2020-03-09 12:00</small>
       </div>
       <p>Good job!</p>
       </div>
       </li>
       <!-- end reply -->
        </ul>
        <!-- ./ end ul -->
      </div>
      <!-- /.panel .chat-panel -->
      </div>
      <div>
      <!-- ./end row -->
</div>
	


<!-- Modal 새로운댓글 모달창-->
      <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
        aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal"
                aria-hidden="true">&times;</button>
              <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <label>Reply</label> 
                <input class="form-control" name='reply' value='New Reply!!!!'>
              </div>      
              <div class="form-group">
                <label>Replyer</label> 
                <input class="form-control" name='replyer' value='replyer'>
              </div>
              <div class="form-group">
                <label>Reply Date</label> 
                <input class="form-control" name='replyDate' value=''>
              </div>
      
            </div>
<div class="modal-footer">
        <button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
        <button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
        <button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
        <button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
      </div>          </div>
          <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
      </div>
      <!-- /.modal -->


<script type="text/javascript" src="/resources/js/reply.js"></script>    <!--reply.js 경로-->

<script>
//댓글 목록, 모달, 등록 이벤트처리 
$(document).ready(function () { 


	var bnoValue = '<c:out value="${board.bno}"/>';
	var replyUL = $(".chat");
	
	showList(1);
	
	//댓글목록 및 이벤트 처리 
	 function showList(page){
	      
	      replyService.getList({bno:bnoValue,page: page|| 1 }, function(replyCnt, list) { //댓글수,댓글목록 전달 
	            	  
	      console.log("replyCnt: "+ replyCnt );
	      console.log("list: " + list);
	      console.log(list);
	    	    
	      if(page == -1){ //페이지번호가 -1로 전달되면 마지막페이지 찾아서 showList(-1) 호출. //새로운댓글 추가되면 전체 댓글개수 다시 계산 후 마지막페이지 호출 
	    	pageNum = Math.ceil(replyCnt/10.0);
	    	showList(pageNum);
	    	return;
	      }
	    	    
	    	var str="";
	    	    
	       if(list == null || list.length == 0){    
	        //replyUL.html("");
	        return;
	      }
	       
	       
	       //댓글 시간처리 
	       for (var i = 0, len = list.length || 0; i < len; i++) {
	           str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
	           str +="  <div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>"; 
	           str +="    <small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
	           str +="    <p>"+list[i].reply+"</p></div></li>";
	         }


	      replyUL.html(str);
	      
	      showReplyPage(replyCnt); //페이지 출력 

	      });//end function
	      
	   }//end showList 
	   
	   //<div class='pannel-footer'>에 댓글페이지번호를 출력하는 로직은 showPage()
	   
	 var pageNum = 1;
	    var replyPageFooter = $(".panel-footer");
	    
	    function showReplyPage(replyCnt){
	      console.log("replyCnt ?????? " + replyCnt);
	      var endNum = Math.ceil(pageNum / 10.0) * 10;  
	      var startNum = endNum - 9; 
	      
	      var prev = startNum != 1;
	      var next = false;
	      
	      if(endNum * 10 >= replyCnt){
	        endNum = Math.ceil(replyCnt/10.0);
	      }
	      
	      if(endNum * 10 < replyCnt){
	        next = true;
	      }
	      
	      var str = "<ul class='pagination pull-right'>";
	      
	      if(prev){
	        str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
	      }
	      
	      for(var i = startNum ; i <= endNum; i++){
	        
	        var active = pageNum == i? "active":"";
	        
	        str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
	      }
	      
	      if(next){
	        str+= "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
	      }
	      
	      str += "</ul></div>";
	      
	      console.log(str);
	      console.log("replyCnt !!!!!!!! " + replyCnt);

	      replyPageFooter.html(str);
	    }
	   
	    
	   //댓글페이지번호를 클릭했을때 새로운 댓글 가져오기
	   replyPageFooter.on("click","li a", function(e){
       e.preventDefault();
       console.log("page click");
       
       var targetPageNum = $(this).attr("href");
       
       console.log("targetPageNum: " + targetPageNum);
       
       pageNum = targetPageNum;
       
       showList(pageNum);
       });     
	   
	   
	    //새로운댓글 모달창 이벤트 처리
	    var modal = $(".modal");
	    var modalInputReply = modal.find("input[name='reply']");
	    var modalInputReplyer = modal.find("input[name='replyer']");
	    var modalInputReplyDate = modal.find("input[name='replyDate']");
	    
	    var modalModBtn = $("#modalModBtn");
	    var modalRemoveBtn = $("#modalRemoveBtn");
	    var modalRegisterBtn = $("#modalRegisterBtn");
	    
	    
	    
	    $("#modalCloseBtn").on("click", function(e){
	    	
	    	modal.modal('hide');
	    });
	    
	    $("#addReplyBtn").on("click", function(e){
	      
	      modal.find("input").val("");
	      modal.find("input[name='replyer']").val(replyer); //모달창에서는 현재 로그인한 사용자이름으로 replyer항목이 고정
	      modalInputReplyDate.closest("div").hide();  //필요없는 정보들은 숨김 
	      modal.find("button[id !='modalCloseBtn']").hide();
	      
	      modalRegisterBtn.show();
	      
	      $(".modal").modal("show");
	      
	    });
	    
	    
	    //ajaxSend()를 이용하여 모든 Ajax전송 CSRF 토큰 같이 전송
	    $(document).ajaxSend(function(e, xhr, options) { 
        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
        }); 

	    
	    
	    //댓글등록 및 댓글갱신 
	    modalRegisterBtn.on("click",function(e){
	        
	        var reply = {
	              reply: modalInputReply.val(), //댓글내용,작성자만으로 추가해서 모달창의 Register버튼 이벤트처리 
	              replyer:modalInputReplyer.val(),
	              bno:bnoValue
	            };
	        replyService.add(reply, function(result){
	          
	          alert(result);
	          
	          modal.find("input").val(""); //댓글내용, 작성자 외 다른 정보 숨김 
	          modal.modal("hide");
	          
	          //showList(1);
	          showList(-1); //새로운댓글을 추가하면, 전체댓글개수파악 후 마지막페이지 호출하여 댓글목록 갱신 
	         	          
	        });
	        
	      });
	    
	    
	   //특정 댓글 클릭 이벤트처리 (jQeury이밴트위임)
	   /* $(".chat").on("click", "li", function(e){ //이미 존재하는 DOM요소에 <ul>태그의 클래스 'chat'을 이용하여 이벤트를 걸고 
	    	var rno = $(this).data("rno"); //나중에 동적으로 생기는 요소들에 대해서 파라미터 형식으로 지정. 
	    	console.log(rno); //실제 이벤트의 대상은 <li>태그가 되도록한다.    	
	   });  */
	   
	    $(".chat").on("click", "li", function(e){ 
	        var rno = $(this).data("rno");

	        //특정댓글 클릭시 모달창에서 보여짐 
	        replyService.get(rno, function(reply){
	    	modalInputReply.val(reply.reply);
	    	modalInputReplyer.val(reply.replyer);
	    	modalInputReplyDate.val(replyService.displayTime( reply.replyDate))
	    	.attr("readonly","readonly");
	    	 modal.data("rno", reply.rno);
	    	
	    	modal.find("button[id !='modalCloseBtn']").hide();
	    	modalModBtn.show();
	    	modalRemoveBtn.show();
	    	
	    	$(".modal").modal("show");
	    	
	        });  
	   	});   
	   
	//댓글수정 이벤트처리 
	/* 
	modalModBtn.on("click", function(e){
    	  
    var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
   	  
 	replyService.update(reply, function(result){
   	        
   	alert(result);
   	modal.modal("hide");
    //showList(1); //수정/삭제후 댓글목록 갱신
   	showList(pageNum); //현재댓글이 포함된 페이지로 이동    	    
   	   });  
    });
	*/
	modalModBtn.on("click", function(e){
  	  
		var originalReplyer = modalInputReplyer.val(); //댓글작성자 함께 전송   
		
		var reply = {
				rno:modal.data("rno"), 
				reply: modalInputReply.val(),
				replyer: originalReplyer}; //댓글작성자 함께 전송
	   	  
	   	  if(!replyer){
	 		  alert("로그인후 수정이 가능합니다.");
	 		  modal.modal("hide");
	 		  return;
	 	  }
	 	  
	 	  console.log("Original Replyer: " + originalReplyer);
	 	  
	 	  if(replyer  != originalReplyer){
	 		  
	 		  alert("자신이 작성한 댓글만 수정이 가능합니다.");
	 		  modal.modal("hide");
	 		  return;	 		  
	 	  }
	   	  
	   	  replyService.update(reply, function(result){
	   	        
	   	    alert(result);
	   	    modal.modal("hide");
	   	    showList(pageNum);	   	    
	   	  });	   	  
	   	});
	
	
	  
    //댓글삭제 이벤트처리 
    /*
    modalRemoveBtn.on("click", function (e){
	    	  
	 var rno = modal.data("rno");
	    	  
	 replyService.remove(rno, function(result){
	    	        
     alert(result);
     modal.modal("hide");
	 showList(1);
	    	      
	 });
	}); */
    
     modalRemoveBtn.on("click", function (e){
   	  
   	  var rno = modal.data("rno");

   	  console.log("RNO: " + rno);
   	  console.log("REPLYER: " + replyer); //댓글작성자 같이 전송 
   	  
   	  if(!replyer){
   		  alert("로그인후 삭제가 가능합니다.");
   		  modal.modal("hide");
   		  return;
   	  }
   	  
   	  var originalReplyer = modalInputReplyer.val();
   	  
   	  console.log("Original Replyer: " + originalReplyer);
   	  
   	  if(replyer  != originalReplyer){
   		  
   		  alert("자신이 작성한 댓글만 삭제가 가능합니다.");
   		  modal.modal("hide");
   		  return;
   		  
   	  }   	  
   	  
   	  replyService.remove(rno, originalReplyer, function(result){ //댓글작성자 추가 
   	        
   	      alert(result);
   	      modal.modal("hide");
   	      showList(pageNum); //현재댓글이 포함된 페이지로 이동 
   	      
   	  });
   	  
   	}); 
	    
	
   //댓글작성자를 Javascript의 변수로 설정
	  var replyer = null;
	    
	    <sec:authorize access="isAuthenticated()">
	    
	    replyer = '<sec:authentication property="principal.username"/>';   
	    
	    </sec:authorize>
	 
	    var csrfHeaderName ="${_csrf.headerName}"; 
	    var csrfTokenValue="${_csrf.token}";
	    
	    
  });
 </script>

  
<script>

console.log("===============");
console.log("JS TEST");

var bnoValue = '<c:out value="${board.bno}"/>';


//for replyService add test replyService.add()
replyService.add(

{reply:"JS Test", replyer:"tester", bno:bnoValue} //Javascript object type
,
function(result){  //Ajax 전송결과 데이터 
  alert("RESULT: " + result);
});   


//reply List Test
replyService.getList({bno:bnoValue, page:1}, function(list){
    
	  for(var i = 0,  len = list.length||0; i < len; i++ ){
	    console.log(list[i]);
	  }
});


//3번 댓글 삭제 테스트 
replyService.remove(3, function(count) {

  console.log(count);

  if (count === "success") {
    alert("REMOVED");
  }
}, function(err) {
  alert('ERROR...');
});


//83번 댓글 수정 
replyService.update({
  rno : 1,
  bno : bnoValue,
  reply : "Modified Reply...."
}, function(result) {

  alert("수정 완료...");

});  


 </script>
 
 
<!--  
<script type="text/javascript">
$(document).ready(function() {
	console.log(replyService);
});
</script>
-->


<script type="text/javascript">
$(document).ready(function() {
	

  var operForm = $("#operForm"); 
  
  //사용자가 버튼을 누르면 bno값이 전달되고 <form>태그를 submit 시켜서 처리 
  $("button[data-oper='modify']").on("click", function(e){  
    
    operForm.attr("action","/board/modify").submit();
    
  });
  

 //사용자가 list로 이동하면 <form>태그 내 bno를 지우고 submit 시켜서 리스트 페이지로 이동 
  $("button[data-oper='list']").on("click", function(e){
    
    operForm.find("#bno").remove();
    operForm.attr("action","/board/list");
    operForm.submit();
    
  });  
 
});
</script>

<!-- 댓글가져오는부분 --> 
<script> 
$(document).ready(function(){ //데이터가져오는부분 즉시 실행 함수 이용 
  
  (function(){
  
    var bno = '<c:out value="${board.bno}"/>';
    
    $.getJSON("/board/getAttachList", {bno: bno}, function(arr){
    
      console.log(arr);
      
      var str = ""; 
      
      //첨부파일이 화면에 보여지는 부분 
      $(arr).each(function(i, attach){
          
          //image type
          if(attach.fileType){
            var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);
            
            str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
            str += "<img src='/display?fileName="+fileCallPath+"'>";
            str += "</div>";
            str +"</li>";
          }else{
              
            str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
            str += "<span> "+ attach.fileName+"</span><br/>";
            str += "<img src='/resources/img/attach.png'></a>";
            str += "</div>";
            str +"</li>";
          }
        });
        
        $(".uploadResult ul").html(str);
      
    }); //end getjson
  });
  
  //일반파일일경우 다운로드처리
  $(".uploadResult").on("click","li", function(e){
      
	    console.log("view image");
	    
	    var liObj = $(this);
	    
	    var path = encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_" + liObj.data("filename"));
	    
	    if(liObj.data("type")){
	      showImage(path.replace(new RegExp(/\\/g),"/")); //파일경로의 경우 함수로 전달 될 때 문제가 생기므로 replace()로 변환후 전달 
	    }else {
	      //download 
	      self.location ="/download?fileName="+path
	    }
	    
	    
	  });
 
  //이미지일경우 원본이미지
  function showImage(fileCallPath){
	    
	    alert(fileCallPath);
	    
	    $(".bigPictureWrapper").css("display","flex").show();
	    
	    $(".bigPicture")
	    .html("<img src='/display?fileName="+fileCallPath+"' >")
	    .animate({width:'100%', height: '100%'}, 1000);
	    
	  }
});


$(".bigPictureWrapper").on("click", function(e){ //원본 이미지 창 닫기 
    $(".bigPicture").animate({width:'0%', height: '0%'}, 1000); //점점 흐려지게 닫는 효과 
    setTimeout(function(){
      $('.bigPictureWrapper').hide();
    }, 1000);
  });
  
</script>


<%@include file="../includes/footer.jsp"%>
