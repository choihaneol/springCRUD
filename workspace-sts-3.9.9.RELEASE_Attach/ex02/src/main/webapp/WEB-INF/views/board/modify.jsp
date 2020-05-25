<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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

      <div class="panel-heading">Board Modify</div>
      <!-- /.panel-heading -->
      <div class="panel-body">
      
      
<!-- 수정/삭제페이지로 이동 -->

<form role="form" action="/board/modify" method="post">    
<!-- <form>태그 내에서 pageNum과 amount 라는 값 전송  -->
<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
<input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'> 
<!--수정/삭제 페이지에서 Criteria의 type,keyword 처리 -->
<input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'> 
 

      
          <!-- 게시물벚호를 보여줄 수 있는 필드 추가 및 readonly지정  -->

          <div class="form-group">
          <label>Bno</label> 
          <input class="form-control" name='bno' 
          value='<c:out value="${board.bno }"/>' readonly="readonly">
          </div>
          
          
          <div class="form-group">
          <label>Title</label> 
          <input class="form-control" name='title' 
          value='<c:out value="${board.title }"/>' >
         </div>
         
         <div class="form-group">
         <label>Text area</label>
         <textarea class="form-control" rows="3" name='content' ><c:out value="${board.content}"/></textarea>
         </div>
         
         <div class="form-group">
         <label>Writer</label> 
         <input class="form-control" name='writer'
         value='<c:out value="${board.writer}"/>' readonly="readonly">            
         </div>
         
         
         <div class="form-group"> <!-- 등록일/수정일은 boardVO로 수집되야 하므로 yyyy/MM/dd 형태 -->
         <label>RegDate</label> 
         <input class="form-control" name='regDate'
         value='<fmt:formatDate pattern = "yyyy/MM/dd" value = "${board.regdate}" />'  readonly="readonly">           
         </div>
          
    
         <div class="form-group">
         <label>Update Date</label> 
         <input class="form-control" name='updateDate'
         value='<fmt:formatDate pattern = "yyyy/MM/dd" value = "${board.updateDate}" />'  readonly="readonly">            
         </div>
           
                 
          <!-- 수정/삭제/목록 버튼  -->
          <button type="submit" data-oper='modify' class="btn btn-default">Modify</button>
          <button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
          <button type="submit" data-oper='list' class="btn btn-info">List</button>
        </form>



      </div>
      <!--  end panel-body -->

    </div>
    <!--  end panel-body -->
  </div>
  <!-- end panel -->
</div>
<!-- /.row -->


<script type="text/javascript">
$(document).ready(function() {


	  var formObj = $("form");

	  $('button').on("click", function(e){  
	    
	    e.preventDefault(); //<a> 태그를 클릭해도 페이지 이동이 없도록 처리 
	    
	    var operation = $(this).data("oper"); 
	    
	    console.log(operation);
	    
	    if(operation === 'remove'){
	      formObj.attr("action", "/board/remove");
	      
	    }else if(operation === 'list'){   //사용자가 다시 목록페이지로 이동
	      //move to list
	      formObj.attr("action", "/board/list").attr("method","get");  //수정된 내용은 클리간 버튼이 list일경우 action,method속성 변경 
	      
	      var pageNumTag = $("input[name='pageNum']").clone(); //<form>태그에서 필요한 부분만 잠시 복사(clone)해서 보관 
	      var amountTag = $("input[name='amount']").clone();
	      var keywordTag = $("input[name='keyword']").clone();  //type과 keyword 추가 
	      var typeTag = $("input[name='type']").clone();
	      
	      formObj.empty(); // /board/list로 이동은 아무런 파라미터가 없기 때문에 <form>태그 내 모든내용 삭제 후, 
	      
	      formObj.append(pageNumTag); //이후에 다시 필요한 태그들만 추가해서 '/board/list'호출  
	      formObj.append(amountTag);    
	      formObj.append(keywordTag); //type과 keyword 추가   
	      formObj.append(typeTag);    
	    }
	    
	    formObj.submit();
	  });

});
</script>


<%@include file="../includes/footer.jsp"%>