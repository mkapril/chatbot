<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
	<title>Welcome to TMC Watson</title>
	<link href="/resources/css/main.css" rel="stylesheet" type="text/css">
<!-- 	<link href="font-awesome.min.css" rel="stylesheet" type="text/css"> -->
<style>

	.loadingCon {
		position:fixed;top:0px;left:0px;width:100%;height:100%;z-index:1000;
	}
	.loadingImage {
	position:absolute;top:50%;left:50%;margin-left:-105px;
/* 	margin-top:-150px; */

	
			width:210px;
			height:212px;
			display:block;
/*  			margin: auto;  */
/* 			position:  center; */
	 		background-image:url(/resources/LoadingImages/loading_630.gif) ; /* 630 x 637 */
 	 		background-size: 50% 50%; 
	 		background-repeat:no-repeat;
/* 	 		vertical-align: middle; */
/* 	 		horizontal-align: middle; */
 	 		background-position:top center; 
	 }
	 
	 .show {
    display: block;
    
    -webkit-animation: slide-down .3s ease-out;
    -moz-animation: slide-down .3s ease-out;
}

@-webkit-keyframes slide-down {
      0% { opacity: 0; -webkit-transform: translateY(-100%); }   
    100% { opacity: 1; -webkit-transform: translateY(0); }
}
@-moz-keyframes slide-down {
      0% { opacity: 0; -moz-transform: translateY(-100%); }   
    100% { opacity: 1; -moz-transform: translateY(0); }
}

.hidden {
	display: none;
	}
	
</style>
	
<script type="text/javascript" src="http://shop.tworld.co.kr/tshop/js/lib/jquery.js"></script>
<script src="/resources/typed.js"></script>

<script type="text/javascript">
	function typedTextByLine (textStrings){
		  Typed.new('.element', {
		        strings: [textStrings],
		        typeSpeed: 0
		      });
		
	}

	/*
	* Jump to 일 때 텍스트 타이핑 재수행 
	*/
	function typedText (textStrings){
		
		
			var filteredText = textStrings.split(",");
				for ( var i=0 ; i< filteredText.length ; i++){
					typedTextByLine(filteredText[i]);
					//sleep(3000);
					//setTimeout(typedTextByLine(filteredText[i]),3000);
					
				}
			
		
	}
	
	function sleep(num){	//[1/1000초]

		 var now = new Date();

		   var stop = now.getTime() + num;

		   while(true){

			 now = new Date();

			 if(now.getTime() > stop)return;

		   }

	}



	function fn_chat(gbn){
		fn_show_loadingbar();
		var message = "";
		if(gbn == 1){
			message = $("#message").val();
			
		}else{
			message = $("#privMessage").val();
		}

		
		$.ajax({
			type : "POST"
			, url : "/call.do"
			, dataType : "JSON"
			, async	: true
			, data : {"Message" : message}
			//, timeout : 3000
			, success : function(d) {
				if(d.resultCd == "S") {
					//$("#return").text(d.message);
					typedText( d.message.replace(/\[/gi,"").replace(/\]/gi,""));
					$("#privMessage").val(message);
					$("#message").val("");
					if (d.resultProductImg != '' && d.resultProductImg != "null"){
						$("#recommended").find("img").attr("src", d.resultProductImg ) ;
						$("#recommended").find("a").attr("href", d.resultProductLink ) ;
						$("#recommended").find("p").html( d.resultProductName );
						
						fn_show_recommendView();
					} else {
						fn_hide_recommendView();
					}
					fn_hide_loadingbar();
				} else if (d.resultCd == "A"){
					typedText( d.message.replace(/\[/gi,"").replace(/\]/gi,""));
					$("#message").val("");
					sleep(2000);
					//fn_chat(2);
				}else{
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
		//typedText("안녕하세요. <br> T word Direct입니다");
		 $( "#message" ).on( "keydown", function(event) {
		      if(event.which == 13) {
		    	  fn_chat(1);
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
	
	/**
	 *	휴대폰 추천 영역 노출 
	 */
	function fn_show_recommendView(){
		$("#recommendBox").removeClass("hidden");
		$("#recommendBox").addClass("show");
		$("#spaces").remove();
	}
	
	/**
	 *	휴대폰 추천 영역 숨김 
	 */
	function fn_hide_recommendView(){
		$("#recommendBox").addClass("hidden");
		$("#recommendBox").removeClass("show");
		$("#spaces").remove();
	}
</script>
</head>
<body >

<div id="page-wrapper">
<input type="hidden" id="privMessage" value="" />
<section id="main" class="container">
		<div id="spaces">
			<br />
			<br />
			<br />
			<br />
			<br />
		</div>
		<h2 class="element"></h2>
<!-- 		 <div class=" row uniform 50%" style="text-align:center;">  -->
		  	
<!-- 		 </div> -->
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
									<input type="button" value="전송"  class="button special color2 fit" onClick="javascript:fn_chat(1); return false;">
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
			
			<div class="row hidden" id="recommendBox" >
				<div class="12u">
					<section class="box">
						<h2>Tailored For You</h2>
						<div id="recommended">
						<div align="center">
							<a target="_blank">
								<img src="" >
								<p> </p>
							</a>
							
						</div> 
							
						</div>
					</section>
				</div>
			</div>
	</section>
</div>
</body>
</html>
