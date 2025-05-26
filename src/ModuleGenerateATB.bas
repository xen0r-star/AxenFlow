Attribute VB_Name = "ModuleGenerateATB"
' Génère un PAE pour un étudiant en format PDF ou XLSX
' Le nom du fichier est personnalisé en fonction des éléments dynamqiue
' Crée un fichier dans un répertoire spécifié ou crée le répertoire si nécessaire
' Si un fichier existe déjà, il propose de le remplacer

Function GenerateATB(ByVal Abbreviation As String, _
                      Optional ByVal Format As String = "PDF", _
                      Optional ByVal filename As String = "[NAME] [SURNAME]", _
                      Optional ByVal Path As String = "\AxenFlow\", _
                      Optional ByVal Preview As String = False) As String
    
    Dim ws As Worksheet
    Dim Data As Object
    Dim SheetExist As Boolean
    Dim answer As Integer
    Dim PathFile As String
    
    
    
    Call ReadData(Abbreviation, Data)
    
    If Not Data Is Nothing Then
        SheetExist = False
        
        If Preview Then
            On Error Resume Next
                Set ws = Sheets("Preview")
            On Error GoTo 0
        
            If Not ws Is Nothing Then
                Application.DisplayAlerts = False
                ws.Delete
                Application.DisplayAlerts = True
            End If
            
            Set ws = Sheets.Add(After:=Sheets(Sheets.count))
            ws.name = "Preview"
            Call CreateSheet(ws, Data)
        
        Else
            For Each ws In Sheets
                If ws.name = Data("Name") & Data("FirstName") Then
                    SheetExist = True
                    Exit For
                End If
            Next ws
            
            If SheetExist Then
                answer = MsgBox("Vous êtes sur le point de supprimer la feuille """ & Data("Name") & Data("FirstName") & """" & vbNewLine & _
                                 "Elle sera supprimée et remplacée par une nouvelle version. Cette action est irréversible." & vbNewLine & vbNewLine & _
                                 "Voulez-vous continuer ?", vbYesNo + vbCritical + vbDefaultButton2, "Confirmation de remplacement")
                
                If answer = vbYes Then
                    Application.DisplayAlerts = False
                    Sheets(Data("Name") & Data("FirstName")).Delete
                    Application.DisplayAlerts = True
                    
                    Set ws = Sheets.Add(After:=Sheets(Sheets.count))
                    ws.name = Data("Name") & Data("FirstName")
                    
                    Call CreateSheet(ws, Data)
                End If
            Else
                Set ws = Sheets.Add(After:=Sheets(Sheets.count))
                ws.name = Data("Name") & Data("FirstName")
                
                Call CreateSheet(ws, Data)
            End If
        End If
        

        
        If Dir(Path, vbDirectory) = "" Then
            MkDir Path
        End If
        
        If Format = "PDF" Then
            PathFile = Path & Replace(Replace(Replace(filename, "[DATE]", SchoolYear("[YEAR1]-[YEAR2]")), "[NAME]", Data("Name")), "[SURNAME]", Data("FirstName")) & ".pdf"
            
            ws.ExportAsFixedFormat Type:=xlTypePDF, filename:=PathFile, _
                                   Quality:=xlQualityStandard, IncludeDocProperties:=True, _
                                   IgnorePrintAreas:=False, OpenAfterPublish:=False
            
        ElseIf Format = "XLSX" Then
            PathFile = Path & Replace(Replace(Replace(filename, "[DATE]", SchoolYear("[YEAR1]-[YEAR2]")), "[NAME]", Data("Name")), "[SURNAME]", Data("FirstName")) & ".xlsx"
            
            ws.Copy
            ActiveWorkbook.SaveAs filename:=PathFile, FileFormat:=xlOpenXMLWorkbook
            ActiveWorkbook.Close False
        End If
        
        GenerateATB = PathFile
        
    Else
    
        GenerateATB = ""
    End If
End Function

Private Sub ReadData(ByVal Abbreviation As String, ByRef Data As Object)
    Dim WsTeacher As Worksheet
    Dim WsMission As Worksheet
    
    Dim position As Integer
    Dim lastCol As Integer
    Dim Table As Variant
    Dim reverseTable() As Variant
    Dim index As Integer
    
    Set WsTeacher = ThisWorkbook.Sheets("Enseignants")
    Set WsMission = ThisWorkbook.Sheets("IntervenantsMissions")
    Set Data = CreateObject("Scripting.Dictionary")
    
    
    
    On Error Resume Next
        position = Application.WorksheetFunction.Match(UCase(Abbreviation), WsTeacher.Range("A:A"), 0)
    On Error GoTo 0
    
    If position <> 0 Then
        Data.Add "Name", Trim(WsTeacher.Cells(position, 2).value)
        Data.Add "FirstName", Trim(WsTeacher.Cells(position, 3).value)
    Else
        Set Data = Nothing
        Exit Sub
    End If


    lastCol = WsMission.Cells(WsMission.Rows.count, 1).End(xlUp).row
    ReDim Table(1 To 2, 1 To lastCol)
    
    index = 0
    For i = 2 To lastCol
        If UCase(WsMission.Cells(i, 2).value) = UCase(Abbreviation) Then
            index = index + 1
            
            Select Case Trim(WsMission.Cells(i, 1).value)
                Case "ID": Table(1, index) = "Informatique - Développement"
                Case "CT": Table(1, index) = "Comptabilité"
                Case "AD": Table(1, index) = "Assistant de direction"
            End Select
            
            Table(2, index) = WsMission.Cells(i, 3).value
        End If
    Next i
    
    If index = 0 Then
        Set Data = Nothing
        Exit Sub
    End If
    
    
    ReDim Preserve Table(1 To 2, 1 To index)
    ReDim reverseTable(1 To index, 1 To 2)
    
    ' Inversion correcte du tableau
    For i = 1 To index
        reverseTable(i, 1) = Table(1, i)
        reverseTable(i, 2) = Table(2, i)
    Next i

    Data("Mission") = reverseTable
End Sub

Private Sub CreateSheet(ByVal ws As Worksheet, Data As Object)
    Dim DataRow As Integer
    Dim criteriaRange As String
    Dim sumRange As String
    
    
    
    Application.PrintCommunication = False
    Application.Calculation = xlCalculationManual
    Application.ScreenUpdating = False

    Columns("A:A").ColumnWidth = 5.2
    Columns("B:B").ColumnWidth = 6.1
    Columns("C:C").ColumnWidth = 7.8
    Columns("D:D").ColumnWidth = 6.885
    Columns("E:E").ColumnWidth = 26
    Columns("F:F").ColumnWidth = 4.4
    Columns("G:G").ColumnWidth = 8
    Columns("H:H").ColumnWidth = 5.9
    Columns("I:I").ColumnWidth = 10.8
    
        
        
    With Range("A1:C3")
        .Merge
        .HorizontalAlignment = xlLeft
        .VerticalAlignment = xlCenter
        .Formula = "=IMAGE(""https://intranet.helha.be/wp-content/uploads/2021/03/LOGO_HELHa.png"", ""Logo Helha"")"
    End With
    
    Range("E1").value = "Matricule.: 5.277.702"
    
    Range("E2").value = "Campus HELHa"
    
    With Range("E3:F3")
        .Merge
        .HorizontalAlignment = xlLeft
        .VerticalAlignment = xlBottom
        
        .value = "Chaussée de Binche, 159 7000 Mons"
    End With
    
    With Range("F1:I1")
        .Merge
        .HorizontalAlignment = xlLeft
        .VerticalAlignment = xlBottom
        
        .value = "Numero: 065.40.41.44"
    End With
    
    With Range("F2:I2")
        .Merge
        .HorizontalAlignment = xlLeft
        .VerticalAlignment = xlBottom
        
        .value = "EMail: secretariat.eco.mons@helha.be"
    End With
        
        
        
    With Range("A6:B6")
        .Merge
        .HorizontalAlignment = xlLeft
        .VerticalAlignment = xlBottom
        
        .value = "Nom / Prénom"
        .Font.Bold = True
        .Font.Color = RGB(255, 255, 255)
        .Interior.Color = RGB(128, 128, 128)
    End With
    
    OutsideEdge Range("A6:B6")
    OutsideEdge Range("A7:B8")
        
        
        
     With Range("D6:G6")
        .Merge
        .VerticalAlignment = xlBottom
        .HorizontalAlignment = xlCenter
        
        .value = "Département Economique et Social"
        .Font.Bold = True
        .Font.Color = RGB(255, 255, 255)
        .Interior.Color = RGB(128, 128, 128)
    End With
    
    With Range("D7:G7")
        .Merge
        .value = SchoolYear
        .Font.Bold = True
        .Font.Color = RGB(255, 255, 255)
        .Interior.Color = RGB(128, 128, 128)
        .HorizontalAlignment = xlCenter
    End With
    
    OutsideEdge Range("D6:G7")
    
    With Range("D8:G8")
        .Merge
        .value = "ATTRIBUTION"
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
    End With
    
    OutsideEdge Range("D8:G8")
        
    
        
    With Range("A7:B7")
        .Merge
        .value = UCase(Data("Name"))
    End With
    
    With Range("A8:B8")
        .Merge
        .value = UCase(Left(Data("FirstName"), 1)) & LCase(Mid(Data("FirstName"), 2))
    End With
    
    
    
    With Range("A10:D10")
        .Merge
        .value = "Section"
        .Font.Bold = True
        .Font.Color = RGB(255, 255, 255)
        .Interior.Color = RGB(128, 128, 128)
        .HorizontalAlignment = xlLeft
    End With
    
    With Range("E10:I10")
        .Merge
        .value = "Attribution"
        .Font.Bold = True
        .Font.Color = RGB(255, 255, 255)
        .Interior.Color = RGB(128, 128, 128)
        .HorizontalAlignment = xlLeft
    End With
    
    OutsideEdge Range("A10:I11")
        
        
        
    DataRow = UBound(Data("Mission"))
        
    For i = 1 To DataRow
        With Range("A" & 11 + (i - 1) & ":D" & 11 + (i - 1))
            .Merge
            .value = Data("Mission")(i, 1)
            
            .Borders.LineStyle = xlContinuous
            .Borders.Weight = xlHairline
            .Borders.Color = RGB(0, 0, 0)
            .HorizontalAlignment = xlLeft
        End With
        
        With Range("E" & 11 + (i - 1) & ":I" & 11 + (i - 1))
            .Merge
            .value = Data("Mission")(i, 2)
            
            .Borders.LineStyle = xlContinuous
            .Borders.Weight = xlHairline
            .Borders.Color = RGB(0, 0, 0)
            .HorizontalAlignment = xlLeft
        End With
    Next i
    
    
    
    OutsideEdge Range("A" & 11 & ":I" & 11 + (DataRow - 1)), True
    
    
    ActiveWindow.View = xlPageLayoutView
    Application.PrintCommunication = True
    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True
    Application.Calculate
End Sub

Private Sub OutsideEdge(ByVal Cell As Range, Optional InsideBorder As Boolean = False)
    With Cell
        .Borders(xlEdgeLeft).Weight = xlThin
        .Borders(xlEdgeRight).Weight = xlThin
        .Borders(xlEdgeTop).Weight = xlThin
        .Borders(xlEdgeBottom).Weight = xlThin
        
        If Not InsideBorder And Cell.count > 1 Then
            .Borders(xlInsideVertical).LineStyle = xlNone
            .Borders(xlInsideHorizontal).LineStyle = xlNone
        End If
    End With
End Sub
