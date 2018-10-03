#? stdtmpl(subsChar = '$', metaChar = '#')
#import xmltree, times, strutils
#
#proc `$!`(text: string): string = xmltree.escape(text)
#end proc
#
#proc renderMain*(title,top,body: string): string =
#  result = ""
# var currTime = int(epochTime())
<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" href="/style.css?${currTime}">
    <title>${title}</title>
  </head>

  <body>
    ${top}<br>
    <div class="centerpiece">
      <a style="text-decoration:none" href="/"><div class="center-title">One-Time File Sharing</div></a>
      <div class="center-body">
        ${body}
      </div>
    </div>
  </body>

</html>
#end proc
#
#
#
#
#proc renderUpload*(): string =
#  result = ""
<div class="slogan">An easy-to-use disposable sharing solution. Simply upload and share the link.</div>
<form action="/upload" method="post" enctype="multipart/form-data">
<input type="file" name="the-file" id="file" class="inputfile" data-multiple-caption="{count} files selected" multiple />
        <label for="file">Choose a file...</label>
        <input placeholder="Lock Password"name="password" type="password">
        <button class="btn" type="post">Upload</button>
</form>
<script>
var inputs = document.querySelectorAll( '.inputfile' );
Array.prototype.forEach.call( inputs, function( input )
{
  var label	 = input.nextElementSibling;
	labelVal = label.innerHTML;

	input.addEventListener( 'change', function( e )
	{
		var fileName = '';
		if( this.files && this.files.length > 1 )
			fileName = ( this.getAttribute( 'data-multiple-caption' ) || '' ).replace( '{count}', this.files.length );
		else
			fileName = e.target.value.split( '\\' ).pop();

    console.log(label);
		if( fileName )
			label.innerHTML = fileName.substring(0,20) + "...";
		else
			label.innerHTML = labelVal;
	});
});
</script>
#end proc
#
#
#
#proc renderSuccess*(fileId: string, fileSize: int, fileName: string): string =
#  result = ""
#  var accessPoint = "http://127.0.0.1:5000/f/" & $fileId
#  var fileSizeMB =  formatFloat((fileSize / 1000000),ffDecimal,2)
<p>
  ${fileSizeMB} MB(s) sucessfully uploaded! You can access the file at:<br>
  <div class="access-link"><a class="alink" href="${accessPoint}">127.0.0.1:5000/f/${fileId}</a></div>
</p>
#end proc
#
#
#proc renderAccess*(fileID: string, fileName: string): string =
#  result = ""
<p>You need to enter the lock password to access this file.</p>
<form action="/g/${fileID}/${fileName}" method="post">
        <input name="password" type="password">
        <button style="margin-left: 10px;" class="btn" type="access">Access</button>
</form>
#end proc
#
#
#proc renderNoAccess*(): string =
# result= ""
<p>File does not exist or has already been accessed!</p>
