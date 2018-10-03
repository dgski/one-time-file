import times, db_sqlite, strutils

type
    Database* = ref object
        db*: DbConn

    fileUpload* = object
        id*: string
        name*: string
        size*: int
        timeUp*: float
        password*: string

#Create Database
proc newDatabase*(filename = "one.db"): Database =
    new result
    result.db = open(filename, "","","")

#Setup Database
proc setup*(database: Database) =
    
    database.db.exec(sql"""
    CREATE TABLE IF NOT EXISTS Uploads(
        id text PRIMARY KEY,
        name text,
        size number,
        timeUp text,
        password text
        );
    """)

#Create Upload
proc create*(database: Database, upload: fileUpload) =
    database.db.exec(sql"INSERT INTO Uploads VALUES (?,?,?,?,?);", 
    upload.id, upload.name, upload.size, upload.timeUp, upload.password)

#Find upload
proc findUpload*(database: Database, inputID: string, upload: var fileUpload): bool =
    let row = database.db.getRow(
        sql"SELECT * FROM Uploads WHERE id = ?;", inputID)
    if row[0].len == 0: return false
    else:
        upload.id = row[0]
        upload.name = row[1]
        upload.size = parseInt(row[2])
        upload.timeUp = parseFloat(row[3])
        upload.password = row[4]
    return true

#Find upload
proc findUploadByFilename*(database: Database, filename: string, upload: var fileUpload): bool =
    let row = database.db.getRow(
        sql"SELECT id FROM Uploads WHERE name = ?;", filename)
    if row[0].len == 0: return false
    else:
        upload.id = row[0]
        upload.name = row[1]
        upload.size = parseInt(row[2])
        upload.timeUp = parseFloat(row[3])
        upload.password = row[4]
    return true

#Delete upload
proc delete*(database: Database, upload: fileUpload) =
    database.db.exec(sql"DELETE FROM Uploads WHERE id = ?;", upload.id)