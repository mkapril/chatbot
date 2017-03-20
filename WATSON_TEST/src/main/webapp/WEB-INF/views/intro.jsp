<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
	<title>Welcome to TMC Watson</title>
	<link href="/resources/css/main.css" rel="stylesheet" type="text/css">
<!-- 	<link href="font-awesome.min.css" rel="stylesheet" type="text/css"> -->
<style>
	.loadingImage {
			width:210px;
			height:212px;
			display:block;
			margin: auto;
			position:  center;
	 		background-image:url(/resources/LoadingImages/loading_630.gif) ; /* 630 x 637 */
 	 		background-size: 50% 50%; 
	 		background-repeat:no-repeat;
/* 	 		vertical-align: middle; */
/* 	 		horizontal-align: middle; */
 	 		background-position:top center; 
	 }
	
</style>
	
<script type="text/javascript" src="http://shop.tworld.co.kr/tshop/js/lib/jquery.js"></script>
<script src="/resources/typed.js"></script>

<script type="text/javascript">
	function typedText (textStrings){
		  Typed.new('.element', {
		        strings: [textStrings],
		        typeSpeed: 0
		      });
	}

	function fn_chat(){
		fn_show_loadingbar();
		var message = $("#message").val();

		
		$.ajax({
			type : "POST"
			, url : "/call.do"
			, dataType : "JSON"
			, async	: true
			, data : {"Message" : message}
			, success : function(d) {
				if(d.resultCd == "S") {
					//$("#return").text(d.message);
					typedText( d.message.replace(/\[/gi,"").replace(/\]/gi,""));
					$("#message").val("");
					fn_hide_loadingbar();
				} else {
					alert(d.msg);
				}
			}, error : function(xhr, status, error) {
				//alert("이건 인공지능이 아니야");
				fn_hide_loadingbar();
				typedText( "잠시 후에 다시 시도해 주세요");
			}
		});
		
	}
	
function fn_call(){
		fn_show_loadingbar();
		$.ajax({
			type : "POST"
			, url : "/fcall.do"
			, dataType : "JSON"
			, async	: true
			, data : {}
			, success : function(d) {
				if(d.resultCd == "S") {
					//$("#return").text(d.message);
					typedText( d.message.replace(/\[/gi,"").replace(/\]/gi,""));
					$("#message").val("");
					fn_hide_loadingbar();
				} else {
					alert(d.msg);
				}
			}, error : function(xhr, status, error) {
				//alert("이건 인공지능이 아니야");
				fn_hide_loadingbar();
				typedText( "잠시 후에 다시 시도해 주세요");
			}
		});
		
	}
	
	$(document).ready(function() {
		typedText("Greetings from Watson.");
		 $( "#message" ).on( "keydown", function(event) {
		      if(event.which == 13) {
		    	  fn_chat();
		      	  return false;
		      }
		    });
		
		fn_call();
	});
	
	function fn_show_loadingbar() {
		if($("div.loadingCon").length > 0) {
			return false;
		}
		
		var loadingHtml = 	"<div class=\"loadingCon\" style=\"text-align: center;\">";
// 			loadingHtml +=	"	<img src=\"/LoadingImages/loading_630.gif\">";
			loadingHtml +=	"	<div class=\"loadingImage\"></div>";
			loadingHtml +=	"</div>";
			loadingHtml +=	"<div id=\"loadingMask\"></div>";
			
		$("body").append(loadingHtml);	
	}
	/**
	 *	로딩바 언바인드 
	 */ 
	function fn_hide_loadingbar() {
		$("div.loadingCon, #loadingMask").remove();	
	}
</script>
</head>
<body >

<div id="page-wrapper">
<section id="main" class="container">
		<br />
		<br />
		<br /><br />
		<br />
		
		 <div class=" row uniform 50%" style="text-align:center;"> 
		  	<h2 class="element"></h2>
		 </div>
		 <div class="row">
		 	<div class="12u">
		 		<section class="box">
				<form id="signup-form">
				<div class="row uniform 50%">
					
<!-- 						<p style="text-align: center;" id="return"></p> -->
<!-- 						<div style="text-align: center; " class="textWrap"> -->
							<div class="9u 12u(mobilep)">
								<input type="text" id="message" />
							</div>
							<div class="3u 12u(mobilep)">
	<!-- 						<ul class="actions"> -->
	<!-- 							<li> -->
									<input type="button" value="전송"  class="button special color2 fit" onClick="javascript:fn_chat(); return false;">
	<!-- 							</li> -->
	<!-- 						</ul> -->
							</div>
<!-- 						</div> -->
					<p></p>
					<div  style="text-align: center;"></div>
					
				</div>
			</form>
			</section>
			</div>
			</div>
	</section>
</div>
</body>
</html>
