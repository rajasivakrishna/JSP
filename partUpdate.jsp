<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Part Details</title>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>

	<form action="${pageContext.request.contextPath}/myservlet" method="post">
	<table style="with: 50%">
	
		<tr>
			<td>Part Number</td>
			<td><input type="text" id="part" name="part"/></td>
		</tr>
	    <tr>
			<td>Quantity</td>
	      	<td><input type="text" id="qty" name="quantity"/></td>
		</tr>
		<tr>
			<td>Transaction Id</td>
			<% String bs_ID = request.getParameter("bsId");%>
			<td><% out.println(bs_ID);%></td>
		</tr>
	</table>
	<input id="sendCPQ" type="button" onclick="UserAction()" value="Add Part to Quote" />
	</form>
<!-- Java Script Code -->
<script type="text/javascript">
	function UserAction() {
		partNum = document.getElementById('part').value;
		qty = document.getElementById('qty').value;
		var bsId="<%=bs_ID%>"; 
		var responseStatus, partRecords;
 	 	if(partNum != '' && qty !='' ){
			var setting1 = {
				  "async": true,
				  "crossDomain": true,
				  "url": "https://cors-anywhere.herokuapp.com/https://cpq-p10-001.bigmachines.com/v2_0/receiver/parts",
				  "method": "POST",
				  "headers": {
				    "content-type": "text/xml",
				    "authorization": "Basic cmFqYXNpdmFrcmlzaG5hOmVeRSNFMV4mNzM=",
				    "cache-control": "no-cache",
				    "postman-token": "c7233846-27b5-20d5-daed-0172cef614e3"
				  },
				  "data": "<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">\r\n  <soapenv:Header>\r\n    <wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\">\r\n      <wsse:UsernameToken wsu:Id=\"UsernameToken-2\">\r\n        <wsse:Username>Karthik</wsse:Username>\r\n        <wsse:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">g]1_E3t1#A</wsse:Password>\r\n      </wsse:UsernameToken>\r\n    </wsse:Security>\r\n  </soapenv:Header>\r\n  <soapenv:Body>\r\n    <bm:getParts xmlns:bm=\"http://xmlns.oracle.com/cpqcloud/parts\">\r\n      <bm:Parts>\r\n        <bm:criteria>\r\n          <bm:field>company_associations</bm:field>\r\n          <bm:value/>\r\n          <bm:comparator>=</bm:comparator>\r\n        </bm:criteria>\r\n        <bm:criteria>\r\n          <bm:field>part_number</bm:field>\r\n          <bm:value>"+partNum+"</bm:value>\r\n          <bm:comparator>=</bm:comparator>\r\n        </bm:criteria>\r\n      </bm:Parts>\r\n    </bm:getParts>\r\n  </soapenv:Body>\r\n</soapenv:Envelope>"
			}
			$.ajax(setting1).done(function (response) {
					console.log(response);
					parser = new DOMParser();
					var res = new XMLSerializer().serializeToString(response);
					xmlDoc = parser.parseFromString(res,"text/xml");
					var responseStatus = xmlDoc.getElementsByTagName("bm:success")[0].childNodes[0].nodeValue;
					var partRecords = xmlDoc.getElementsByTagName("bm:records_returned")[0].childNodes[0].nodeValue;
					//alert(responseStatus);
					//alert(partRecords);
					if(responseStatus == 'true' && partRecords != '0'){
						 var settings = {
								  "async": true,
								  "crossDomain": true,
								  "url": "https://cors-anywhere.herokuapp.com/https://cpq-p10-001.bigmachines.com/v2_0/receiver/commerce/oraclecpqo_bmClone_5",
								  "method": "POST",
								  "headers": {
									"content-type": "text/xml",
									"cache-control": "no-cache",
									"postman-token": "72bb6756-65c7-fcaa-3a28-cceddbdf16e4"
								  },
								  "data": "<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\">\r\n  <soapenv:Header>\r\n    <wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\">\r\n      <wsse:UsernameToken wsu:Id=\"UsernameToken-2\">\r\n        <wsse:Username>Karthik</wsse:Username>\r\n        <wsse:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">g]1_E3t1#A</wsse:Password>\r\n      </wsse:UsernameToken>\r\n    </wsse:Security>\r\n  </soapenv:Header>\r\n  <soapenv:Body>\r\n    <bm:addToTransaction xmlns:bm=\"http://xmlns.oracle.com/cpqcloud/commerce/oraclecpqo_bmClone_5\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\r\n      <bm:items>\r\n        <bm:partItem>\r\n          <bm:part>"+partNum+"</bm:part>\r\n          <bm:quantity>"+qty+"</bm:quantity>\r\n          <bm:price_book_var_name>_default_price_book</bm:price_book_var_name>\r\n        </bm:partItem>\r\n      </bm:items>\r\n      <bm:transaction>\r\n        <bm:process_var_name>oraclecpqo_bmClone_5</bm:process_var_name>\r\n        <bm:id>"+bsId+"</bm:id>\r\n          <bm:action_data>\r\n          <bm:document_var_name>transaction</bm:document_var_name>\r\n        </bm:action_data>\r\n      </bm:transaction>\r\n      <bm:include_transaction>true</bm:include_transaction>\r\n    </bm:addToTransaction>\r\n  </soapenv:Body>\r\n</soapenv:Envelope>"
								}
						$.ajax(settings).done(function (response) {
						//alert(bsId);
						var urlPath = "https://cpq-p10-001.bigmachines.com/commerce/transaction/oraclecpqo_bmClone_5/"+bsId;
						//alert(urlPath);
						window.location.href=urlPath;
						console.log(response);
						//alert("End");
						});
					}
					else{
						alert("No parts exists with entered part number..!");
					}
      		});
         }
      	 else{
      	 	alert("Both Part Number and Quantity are mandatory..!");
      	 }
	};
</script>
</body>
</html>