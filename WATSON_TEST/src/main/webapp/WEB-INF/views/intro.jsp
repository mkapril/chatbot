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

/* .newphoneList>div{background:#f9f9f9;padding:60px 0 90px;} */
.newphoneList .con ul {overflow:hidden;margin-top:-30px;}
.newphoneList .con ul li {position:relative;float:left;width:279px;height:198px;margin-top:60px;padding-top:282px;text-align:center;}
.newphoneList .con ul li dl dt {height:40px;font-family:'Verdana';font-size:18px;font-weight:bold;color:#333;overflow:hidden;}
.newphoneList .con ul li .img {position:absolute;top:0;left:50%;margin-left:-120px;}
.newphoneList .con ul li .img{width:230px;}
.newphoneList .con ul{margin:40px 0 0 -20px;}
.newphoneList .con ul li{width:400px;min-height:206px;margin:0 0 20px 20px; padding:282px 20px 20px; background:#fff;}

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

	function refresh() {
		self.location.reload(true);
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
					typedTextByLine( d.message.replace(/\[/gi,"").replace(/\]/gi,"").replace(/\,/gi,"<BR />"));
					fn_hide_loadingbar();
					$("#privMessage").val(message);
					$("#message").val("");
					
				} else if (d.resultCd == "A"){
					typedTextByLine( d.message.replace(/\[/gi,"").replace(/\]/gi,""));
					fn_hide_loadingbar();
					if("" != $("#privMessage").val() ){
						$("#message").val("");
						sleep(1000);
						fn_chat(2);
					}else {
						$("#message").val("");
						fn_call();
					}
				} else if (d.resultCd == "E"){
					typedTextByLine( d.message.replace(/\[/gi,"").replace(/\]/gi,"").replace(/\,/gi,"<BR />"));
					$("#privMessage").val(message);
					$("#messageDiv").addClass("hidden");
					$("#submit").hide();
					$("#refresh").show();
					fn_hide_loadingbar();
					fn_show_recommendView(d.resultProduct);
				} else {
					//alert('!!');
				}
			}, error : function(xhr, status, error) {
				fn_hide_loadingbar();
				typedTextByLine( "잠시 후에 다시 시도해 주세요");
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
					typedTextByLine( d.message.replace(/\[/gi,"").replace(/\]/gi,"").replace(/\,/gi,"<BR />"));
					$("#message").val("");
					fn_hide_loadingbar();
				} else {
					alert(d.msg);
					fn_hide_loadingbar();
				}
			}, error : function(xhr, status, error) {
				//alert("이건 인공지능이 아니야");
				fn_hide_loadingbar();
				typedTextByLine( "잠시 후에 다시 시도해 주세요");
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
	function fn_show_recommendView(gbn){
		if(gbn == '[E_galaxy7]'){
			$("#recommendBox").removeClass("hidden");
			$("#recommendBox").addClass("show");
			$("#galaxy").show();
			$("#spaces").remove();
		} else if (gbn == '[E_apple]'){
			$("#recommendBox").removeClass("hidden");
			$("#recommendBox").addClass("show");
			$("#iphone7").show();
			$("#spaces").remove();
		} else if (gbn == '[E_reasonable]') {
			$("#recommendBox").removeClass("hidden");
			$("#recommendBox").addClass("show");
			$("#reason").show();
			$("#spaces").remove();
		} else if (gbn == '[E_wearable]') {
			$("#recommendBox").removeClass("hidden");
			$("#recommendBox").addClass("show");
			$("#wearable").show();
			$("#spaces").remove();
		} else if (gbn == '[E_kitty]') {
			$("#recommendBox").removeClass("hidden");
			$("#recommendBox").addClass("show");
			$("#kitty").show();
			$("#spaces").remove();
		}
		
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
							<div class="9u 12u(mobilep)" id="messageDiv">
								<input type="text" id="message" />
							</div>
							<div class="3u 12u(mobilep)" id="submit">
									<input type="button" value="전송"  class="button special color2 fit" onClick="javascript:fn_chat(1); return false;">
							</div>
							<div class="12u 12u(mobilep)" id="refresh" style="display: none;">
									<input type="button" value="처음으로"  class="button special color2 fit" onClick="javascript:refresh();">
							</div>
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
						<div id="recommended" >
							<div class="newphoneList">
								<div class="con" id="galaxy" style="display: none;">
									<h2>당신을 위한 맞춤 추천!</h2>
									<ul>
										<li>
											<dl>
												<dt>갤럭시 S7</dt>
												<dd class="img">
													<a href="http://shop.tworld.co.kr/handler/PhoneDetail-Start?PRODUCT_GRP_ID=000001152&SUBSCRIPTION_ID=NA00004775&CATEGORY_ID=20010001&REL_CATEGORY_ID=30010024&COLOR_HEX=ACAFB4&callGnb=01", target="_blank">
														<img src="http://shop.tworld.co.kr/pimg/phone/SS/SS56/default/SS56_001_1.jpg">
													</a>
												</dd>
											</dl>
											
										</li>
										
										<li>
											<dl>
												<dt>갤럭시 S7 edge</dt>
												<dd class="img">
													<a href="http://shop.tworld.co.kr/handler/PhoneDetail-Start?PRODUCT_GRP_ID=000001153&SUBSCRIPTION_ID=NA00004775&CATEGORY_ID=20010001&REL_CATEGORY_ID=30010024&COLOR_HEX=000205&callGnb=01", target="_blank">
														<img src="http://shop.tworld.co.kr/pimg/phone/SS/SS2L/default/SS2L_001_1.jpg" >
													</a>
												</dd>
											</dl>
										</li>
										
									</ul>
								</div>
								<div class="con" id="iphone7" style="display: none;">
									<h2>당신을 위한 맞춤 추천!</h2>
									<ul>
										<li>
											<dl>
												<dt>iPhone 7</dt>
												<dd class="img">
													<a href="http://shop.tworld.co.kr/handler/PhoneDetail-Start?PRODUCT_GRP_ID=000001672&SUBSCRIPTION_ID=NA00004775&CATEGORY_ID=20010001&REL_CATEGORY_ID=30010024&COLOR_HEX=AA1C28&callGnb=01", target="_blank">
														<img src="http://shop.tworld.co.kr/pimg/phone/CG/CGNR/default/CGNR_001_1.jpg">
													</a>
												</dd>
											</dl>
										</li>
										
										<li>
											<dl>
												<dt>iPhone7+</dt>
												<dd class="img">
													<a href="http://shop.tworld.co.kr/handler/PhoneDetail-Start?PRODUCT_GRP_ID=000001673&SUBSCRIPTION_ID=NA00004775&CATEGORY_ID=20010001&REL_CATEGORY_ID=30010024&COLOR_HEX=AA1C28&callGnb=01", target="_blank">
														<img src="http://shop.tworld.co.kr/pimg/phone/CG/CGNS/default/CGNS_001_1.jpg" >
													</a>
												</dd>
											</dl>
										</li>
										
									</ul>
								</div>
								<div class="con" id="reason" style="display: none;">
									<h2>당신을 위한 맞춤 추천!</h2>
									<ul>
										<li>
											<dl>
												<dt>Galaxy A8 2016</dt>
												<dd class="img">
													<a href="http://shop.tworld.co.kr/handler/PhoneDetail-Start?PRODUCT_GRP_ID=000001612&SUBSCRIPTION_ID=NA00004775&CATEGORY_ID=20010001&REL_CATEGORY_ID=30010024&COLOR_HEX=D2E1E8&callGnb=01", target="_blank">
														<img src="http://shop.tworld.co.kr/pimg/phone/SS/SS1E/default/SS1E_001_1.jpg">
													</a>
												</dd>
											</dl>
										</li>
										
										<li>
											<dl>
												<dt>SKY IM-100</dt>
												<dd class="img">
													<a href="http://shop.tworld.co.kr/handler/PhoneDetail-Start?PRODUCT_GRP_ID=000001412&SUBSCRIPTION_ID=NA00004775&CATEGORY_ID=20010001&REL_CATEGORY_ID=30010024&COLOR_HEX=FFFFFF&callGnb=01", target="_blank">
														<img src="http://shop.tworld.co.kr/pimg/phone/PT/PTY9/default/PTY9_001_1.jpg" >
													</a>
												</dd>
											</dl>
										</li>
										
									</ul>
								</div>
								<div class="con" id="wearable" style="display: none;">
									<h2>당신을 위한 맞춤 추천!</h2>
									<ul>
										<li>
											<dl>
												<dt>JOON 3</dt>
												<dd class="img">
													<a href="http://shop.tworld.co.kr/handler/PhoneDetail-Start?PRODUCT_GRP_ID=000001613&SUBSCRIPTION_ID=NA00004484&CATEGORY_ID=undefined&REL_CATEGORY_ID=undefined&COLOR_HEX=F6A3BA&callGnb=01", target="_blank">
														<img src="http://shop.tworld.co.kr/pimg/phone/FL/FLC8/default/FLC8_004_1.jpg">
													</a>
												</dd>
											</dl>
										</li>
										
										<li>
											<dl>
												<dt>JOON 2</dt>
												<dd class="img">
													<a href="http://shop.tworld.co.kr/handler/PhoneDetail-Start?PRODUCT_GRP_ID=000000632&SUBSCRIPTION_ID=NA00004484&CATEGORY_ID=undefined&REL_CATEGORY_ID=undefined&COLOR_HEX=FFFFFF&callGnb=01", target="_blank">
														<img src="http://shop.tworld.co.kr/pimg/phone/FL/FLC5/default/FLC5_002_1.jpg" >
													</a>
												</dd>
											</dl>
										</li>
										
									</ul>
								</div>
								<div class="con" id="kitty" style="display: none;">
									<h2>당신을 위한 맞춤 추천!</h2>
									<ul>
										<li>
											<dl>
												<dt>헬로키티폰</dt>
												<dd class="img">
													<a href="http://shop.tworld.co.kr/handler/PhoneDetail-Start?PRODUCT_GRP_ID=000001892&SUBSCRIPTION_ID=NA00002669&CATEGORY_ID=undefined&REL_CATEGORY_ID=undefined&COLOR_HEX=FFFFFF&callGnb=01", target="_blank">
														<img src="http://shop.tworld.co.kr/pimg/phone/MZ/MZ01/default/MZ01_001_1.jpg">
													</a>
												</dd>
											</dl>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</section>
				</div>
			</div>
	</section>
</div>
</body>
</html>
