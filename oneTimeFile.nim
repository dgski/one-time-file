import jester, asyncdispatch, htmlgen, httpcore, json, tables, times, hashes, strutils, os
import views, database

var db {.threadvar.}: Database
db = newDatabase()
db.setup()

proc indexGen(): string =
    var header = "<img class='header' src='/pro.svg'>"
    return renderMain("One Time File Upload",header,renderUpload())

proc accessGen(fileID: string): string =
    var upload: fileUpload
    if db.findUpload(fileID, upload):
        return renderMain("Accessing File","", renderAccess(fileID, upload.name))
    else:
        return renderMain("File Not Found","", renderNoAccess())

proc uploadGen(request: Request): string =
    if request.formData.getOrDefault("the-file").body == "":
        return "error"
    #Create file upload
    var newfile: fileUpload
    newfile.id = $hash(request.formData.getOrDefault("the-file").body & $epochTime())
    newfile.name = request.formData.getOrDefault("the-file").fields["filename"]
    newfile.size = request.formData.getOrDefault("the-file").body.len
    newfile.timeUp = epochTime()
    newfile.password = $hash(request.formData.getOrDefault("password").body)
    #Add to db
    db.create(newfile)
    #Save file in storage
    writeFile("files/" & $(newfile.id), request.formData.getOrDefault("the-file").body)
    return renderMain("File Uploaded!","",renderSuccess(newfile.id,newfile.size,newfile.name))

routes:
    get "/":
        resp indexGen()
    post "/upload":
        var upload = uploadGen(request)
        if upload == "error":
            redirect "/"
        else:
            resp upload
    get "/f/@name":
        resp accessGen(@"name")
    post "/g/@id/@filename":
        var fileID = @"id"
        var submitted = $hash(request.params["password"])

        var upload: fileUpload
        if db.findUpload(fileID, upload) == false:
            resp renderMain("File Not Found","", renderNoAccess())

        if(upload.password == submitted):
            var data = readFile("files/" & upload.id)
            db.delete(upload)
            resp(data, "application")
        else:
            resp renderMain("No Access","", "Password provided is incorrect.")

runForever()