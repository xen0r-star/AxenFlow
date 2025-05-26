Attribute VB_Name = "ModuleGeneratePAE"
' Génère un PAE pour un étudiant en format PDF ou XLSX
' Le nom du fichier est personnalisé en fonction des éléments dynamqiue
' Crée un fichier dans un répertoire spécifié ou crée le répertoire si nécessaire
' Si un fichier existe déjà, il propose de le remplacer

Function GeneratePAE(ByVal Matricule As String, _
                      Optional ByVal Format As String = "PDF", _
                      Optional ByVal filename As String = "PAE_[DATE]_[NAME]_[SURNAME]", _
                      Optional ByVal Path As String = "\AxenFlow\", _
                      Optional ByVal Info As String = "All", _
                      Optional ByVal Preview As String = False) As String
    
    Dim ws As Worksheet
    Dim Person As Object
    Dim Data As Object
    Dim SheetExist As Boolean
    Dim answer As Integer
    Dim PathFile As String
    
    
    Call ReadData(Matricule, Person, Data, Info)
    
    If Not Person Is Nothing Then
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
            Call CreateSheet(ws, Person, Data)
        
        Else
            For Each ws In Sheets
                If ws.name = Person("Name") & Person("FirstName") Then
                    SheetExist = True
                    Exit For
                End If
            Next ws
        
            If SheetExist Then
                answer = MsgBox("Vous êtes sur le point de supprimer la feuille """ & Person("Name") & Person("FirstName") & """" & vbNewLine & _
                                 "Elle sera supprimée et remplacée par une nouvelle version. Cette action est irréversible." & vbNewLine & vbNewLine & _
                                 "Voulez-vous continuer ?", vbYesNo + vbCritical + vbDefaultButton2, "Confirmation de remplacement")
                
                If answer = vbYes Then
                    Application.DisplayAlerts = False
                    Sheets(Person("Name") & Person("FirstName")).Delete
                    Application.DisplayAlerts = True
                    
                    Set ws = Sheets.Add(After:=Sheets(Sheets.count))
                    ws.name = Person("Name") & Person("FirstName")
                    
                    Call CreateSheet(ws, Person, Data)
                End If
            Else
                Set ws = Sheets.Add(After:=Sheets(Sheets.count))
                ws.name = Person("Name") & Person("FirstName")
                
                Call CreateSheet(ws, Person, Data)
            End If
        End If
        
        
        
        If Dir(Path, vbDirectory) = "" Then
            MkDir Path
        End If
        
        If Format = "PDF" Then
            PathFile = Path & Replace(Replace(Replace(filename, "[DATE]", SchoolYear("[YEAR1]-[YEAR2]")), "[NAME]", Person("Name")), "[SURNAME]", Person("FirstName")) & ".pdf"
            
            ws.ExportAsFixedFormat Type:=xlTypePDF, filename:=PathFile, _
                                   Quality:=xlQualityStandard, IncludeDocProperties:=True, _
                                   IgnorePrintAreas:=False, OpenAfterPublish:=False
            
        ElseIf Format = "XLSX" Then
            PathFile = Path & Replace(Replace(Replace(filename, "[DATE]", SchoolYear("[YEAR1]-[YEAR2]")), "[NAME]", Person("Name")), "[SURNAME]", Person("FirstName")) & ".xlsx"
            
            ws.Copy
            ActiveWorkbook.SaveAs filename:=PathFile, FileFormat:=xlOpenXMLWorkbook
            ActiveWorkbook.Close False
        End If
        
        GeneratePAE = PathFile
    
    Else
        GeneratePAE = ""
    End If
End Function

Private Sub ReadData(ByVal Matricule As String, ByRef Person As Object, _
                     ByRef Data As Object, Optional ByVal Info As String = "All")
    Dim WsStudent As Worksheet
    Dim WsPointGrill As Worksheet
    
    Dim foundCell As Range
    Dim position As Integer
    Dim lastRow As Integer
    Dim lastCol As Integer
    Dim fullText As String
    Dim courseParts As Variant
    Dim numberBloc As Integer
    
    Dim Table As Variant
    Dim values(1 To 5) As String
    
    Set WsStudent = ThisWorkbook.Sheets("Etudiants")
    Set WsPointGrill = ThisWorkbook.Sheets("GrillePoints")
    Set Person = CreateObject("Scripting.Dictionary")
    Set Data = CreateObject("Scripting.Dictionary")
    
    
    
    On Error Resume Next
        position = Application.WorksheetFunction.Match(Matricule, WsStudent.Range("A:A"), 0)
    On Error GoTo 0
    
    If position <> 0 Then
        Person.Add "Name", Trim(WsStudent.Cells(position, 2).value)
        Person.Add "FirstName", Trim(WsStudent.Cells(position, 3).value)
    
        Select Case Trim(WsStudent.Cells(position, 4).value)
            Case "ID": Person.Add "Orientation", "Informatique - Développement"
            Case "CT": Person.Add "Orientation", "Comptabilité"
            Case "AD": Person.Add "Orientation", "Assistant de direction"
        End Select
    Else
        Set Person = Nothing
        Exit Sub
    End If
    
    
    lastRow = WsPointGrill.Cells(Rows.count, 1).End(xlUp).row
    
    On Error Resume Next
        For Each Cell In WsPointGrill.Range("B1:B" & lastRow).Cells
            If Cell.value Like "*" & Trim(Person("Name") & " " & Person("FirstName")) & "*" Then
                Set foundCell = Cell
                Exit For
            End If
        Next Cell
    On Error GoTo 0

    If Not foundCell Is Nothing Then
        position = foundCell.row
        startPos = InStr(Trim(WsPointGrill.Cells(position, 2).value), "(") + 1
        endPos = InStr(Trim(WsPointGrill.Cells(position, 2).value), ")")
    
        If startPos > 0 And endPos > 0 Then
            Person.Add "Class", Mid(Trim(WsPointGrill.Cells(position, 2).value), startPos, endPos - startPos)
        End If
    Else
        Set Person = Nothing
        Exit Sub
    End If
    
    
    
    lastCol = WsPointGrill.Cells(1, WsPointGrill.Columns.count).End(xlToLeft).Column
    
    For i = 3 To lastCol
        If WsPointGrill.Cells(1, i).value <> "" Then
            
            fullText = WsPointGrill.Cells(1, i).value
            courseParts = Split(fullText, " : ")

            If UBound(courseParts) = 1 Then
                numberBloc = Trim(Mid(courseParts(0), 5, 1))
                
                If InStr(1, UCase(Trim(WsPointGrill.Cells(2, i).value)), "UE", vbTextCompare) > 0 Then
                    values(1) = Left(Trim(WsPointGrill.Cells(2, i).value), 2)
                Else
                    values(1) = Trim(WsPointGrill.Cells(2, i).value)
                End If
                
                values(2) = Trim(courseParts(0))
                values(3) = Trim(courseParts(1))
                
                If InStr(1, LCase(fullText), "(p)", vbTextCompare) > 0 Then
                    values(4) = "1 - 2"
                    values(3) = Replace(values(3), "(p)", "")
                Else
                    values(4) = "1"
                End If
            
                values(4) = IIf(values(1) = "AcAp", "", values(4))
                values(5) = Trim(WsPointGrill.Cells(3, i).value)
                
                If Not Data.Exists("Bloc_" & numberBloc) Then
                    ReDim Table(1 To 5, 1 To 1)
                    
                    For j = 1 To 5
                        Table(j, 1) = values(j)
                    Next j
                    
                    Data.Add "Bloc_" & numberBloc, Table
                Else
                    Table = Data("Bloc_" & numberBloc)
                    n = UBound(Table, 2) + 1
                    
                    ReDim Preserve Table(1 To 5, 1 To n)
                    
                    For j = 1 To 5
                        Table(j, n) = values(j)
                    Next j
                    
                    Data("Bloc_" & numberBloc) = Table
                End If
            End If
        End If
    Next i
    
    
    
    ' inversion tableau (lig, col -> col, lig) du au Redim Preserve
    For numberBloc = 1 To 3
        Table = Data("Bloc_" & numberBloc)
        
        Dim reverseTable() As Variant
        ReDim reverseTable(1 To UBound(Table, 2), 1 To 5)
        
        For i = 1 To UBound(Table, 1)
            For j = 1 To UBound(Table, 2)
                reverseTable(j, i) = Table(i, j)
            Next j
        Next i

        Data("Bloc_" & numberBloc) = reverseTable
    Next numberBloc
    
    
    
    ' Trie donnee necessaire
    If Info = "Minimum" Then
        
    End If
End Sub

Private Sub CreateSheet(ByVal ws As Worksheet, Person As Object, Data As Object)
    Dim DataRow As Integer
    Dim colOffset As Integer
    Dim criteriaRange As String
    Dim sumRange As String
    
    
    
    Application.PrintCommunication = False
    Application.Calculation = xlCalculationManual
    Application.ScreenUpdating = False

    For index = 0 To Data.count - 1
        colOffset = (index) * 9

        ws.Columns(1 + colOffset).ColumnWidth = 5.2
        ws.Columns(2 + colOffset).ColumnWidth = 6.1
        ws.Columns(3 + colOffset).ColumnWidth = 7.8
        ws.Columns(4 + colOffset).ColumnWidth = 6.885
        ws.Columns(5 + colOffset).ColumnWidth = 26
        ws.Columns(6 + colOffset).ColumnWidth = 4.4
        ws.Columns(7 + colOffset).ColumnWidth = 8
        ws.Columns(8 + colOffset).ColumnWidth = 5.9
        ws.Columns(9 + colOffset).ColumnWidth = 10.8
        
        
        With ws.Range(Cells(1, 1 + colOffset), Cells(3, 3 + colOffset))
            .Merge
            .HorizontalAlignment = xlLeft
            .VerticalAlignment = xlCenter
            
            .Formula = "=IMAGE(""https://intranet.helha.be/wp-content/uploads/2021/03/LOGO_HELHa.png"", ""Logo Helha"")"
        End With
        
        ws.Cells(1, 5 + colOffset).value = "Matricule.: 5.277.702"
        ws.Cells(2, 5 + colOffset).value = "Campus HELHa"
        
        With ws.Range(Cells(3, 5 + colOffset), Cells(3, 6 + colOffset))
            .Merge
            .HorizontalAlignment = xlLeft
            .VerticalAlignment = xlBottom
            
            .value = "Chaussée de Binche, 159 7000 Mons"
        End With
        
        With ws.Range(Cells(1, 6 + colOffset), Cells(1, 9 + colOffset))
            .Merge
            .HorizontalAlignment = xlLeft
            .VerticalAlignment = xlBottom
            
            .value = "Numero: 065.40.41.44"
        End With
        
        With ws.Range(Cells(2, 6 + colOffset), Cells(2, 9 + colOffset))
            .Merge
            .HorizontalAlignment = xlLeft
            .VerticalAlignment = xlBottom
            
            .value = "EMail: secretariat.eco.mons@helha.be"
        End With
        
        
        
        With ws.Range(Cells(6, 1 + colOffset), Cells(6, 2 + colOffset))
            .Merge
            .HorizontalAlignment = xlLeft
            .VerticalAlignment = xlBottom
            
            .value = "Nom / Prénom"
            .Font.Bold = True
            .Font.Color = RGB(255, 255, 255)
            .Interior.Color = RGB(128, 128, 128)
        End With
        
        With ws.Cells(6, 3 + colOffset)
            .value = "Classe"
            .Font.Bold = True
            .Font.Color = RGB(255, 255, 255)
            .Interior.Color = RGB(128, 128, 128)
        End With
        
        OutsideEdge ws.Range(Cells(6, 1 + colOffset), Cells(6, 3 + colOffset))
        OutsideEdge ws.Range(Cells(7, 1 + colOffset), Cells(8, 3 + colOffset))
        
        
        
        With ws.Range(Cells(6, 5 + colOffset), Cells(6, 7 + colOffset))
            .Merge
            .HorizontalAlignment = xlCenter
            .VerticalAlignment = xlBottom
            
            .value = "Département Economique et Social"
            .Font.Bold = True
            .Font.Color = RGB(255, 255, 255)
            .Interior.Color = RGB(128, 128, 128)
        End With
        
        With ws.Cells(7, 5 + colOffset)
            .value = Person("Orientation")
            .Font.Bold = True
            .Font.Color = RGB(255, 255, 255)
            .Interior.Color = RGB(128, 128, 128)
            .HorizontalAlignment = xlCenter
        End With
        
        With ws.Range(Cells(7, 6 + colOffset), Cells(7, 7 + colOffset))
            .Merge
            .value = SchoolYear
            .Font.Bold = True
            .Font.Color = RGB(255, 255, 255)
            .Interior.Color = RGB(128, 128, 128)
            .HorizontalAlignment = xlCenter
        End With
        
        OutsideEdge ws.Range(Cells(6, 5 + colOffset), Cells(7, 7 + colOffset))
        
        With Range(Cells(8, 5 + colOffset), Cells(8, 7 + colOffset))
            .Merge
            .value = "PAE"
            .Font.Bold = True
            .HorizontalAlignment = xlCenter
        End With
        
        OutsideEdge ws.Range(Cells(8, 5 + colOffset), Cells(8, 7 + colOffset))
        
        
        
        With ws.Cells(6, 9 + colOffset)
            .value = "Crédit"
            .Font.Bold = True
            .Font.Color = RGB(255, 255, 255)
            .Interior.Color = RGB(128, 128, 128)
            .HorizontalAlignment = xlCenter
        End With
        
        With ws.Cells(7, 9 + colOffset)
            .value = "total"
            .Font.Bold = True
            .Font.Color = RGB(255, 255, 255)
            .Interior.Color = RGB(128, 128, 128)
            .HorizontalAlignment = xlCenter
        End With
        
        OutsideEdge ws.Range(Cells(6, 9 + colOffset), Cells(7, 9 + colOffset))
        OutsideEdge ws.Cells(8, 9 + colOffset)
        
        
        
        With ws.Range(Cells(7, 1 + colOffset), Cells(7, 2 + colOffset))
            .Merge
            .value = UCase(Person("Name"))
        End With
        
        With ws.Range(Cells(8, 1 + colOffset), Cells(8, 2 + colOffset))
            .Merge
            .value = UCase(Left(Person("FirstName"), 1)) & LCase(Mid(Person("FirstName"), 2))
        End With
        
        ws.Cells(7, 3 + colOffset).value = Replace(UCase(Person("Class")), " ", "")
        
        
        
        With ws.Range(Cells(10, 1 + colOffset), Cells(11, 9 + colOffset))
            .Font.Bold = True
            .Font.Color = RGB(255, 255, 255)
            .Interior.Color = RGB(128, 128, 128)
            .HorizontalAlignment = xlLeft
        End With
        
        OutsideEdge ws.Range(Cells(10, 1 + colOffset), Cells(11, 9 + colOffset))
        
        ws.Cells(10, 1 + colOffset).value = Replace(Data.Keys()(index), "_", " ")
        
        With ws.Range(Cells(10, 2 + colOffset), Cells(11, 4 + colOffset))
            .Merge
            .value = "Code ECTS"
            .Font.Italic = True
        End With
        
        With ws.Range(Cells(10, 5 + colOffset), Cells(11, 7 + colOffset))
            .Merge
            .value = "Nom d'UE / AcAp"
            .Font.Italic = True
        End With
        
        With ws.Range(Cells(10, 8 + colOffset), Cells(11, 8 + colOffset))
            .Merge
            .value = "Qua"
            .Font.Italic = True
        End With
        
        With ws.Range(Cells(10, 9 + colOffset), Cells(11, 9 + colOffset))
            .Merge
            .value = "Crédits"
            .Font.Italic = True
        End With
        
        
        
        DataRow = UBound(Data(Data.Keys()(index)))
        
        For i = 1 To DataRow
            For j = 1 To 5
                Select Case j
                    Case 1
                        ws.Cells(12 + i - 1, 1 + colOffset).Select
        
                    Case 2
                        ws.Range(Cells(12 + i - 1, 2 + colOffset), Cells(12 + i - 1, 4 + colOffset)).Select
                        Selection.Merge
        
                    Case 3
                        ws.Range(Cells(12 + i - 1, 5 + colOffset), Cells(12 + i - 1, 7 + colOffset)).Select
                        Selection.Merge
        
                    Case 4
                        ws.Cells(12 + i - 1, 8 + colOffset).Select
        
                    Case 5
                        ws.Cells(12 + i - 1, 9 + colOffset).Select
        
                End Select
                
                With Selection
                    If Not IsNumeric(Data(Data.Keys()(index))(i, j)) Then
                        .NumberFormat = "@"
                    End If
                    
                    .value = Data(Data.Keys()(index))(i, j)
                    
                    .Borders.LineStyle = xlContinuous
                    .Borders.Weight = xlHairline
                    .Borders.Color = RGB(0, 0, 0)
                    .HorizontalAlignment = xlLeft
        
                    If InStr(1, Data(Data.Keys()(index))(i, 1), "UE", vbTextCompare) > 0 Then
                        With .Borders(xlEdgeTop)
                            .LineStyle = xlContinuous
                            .ColorIndex = 0
                            .TintAndShade = 0
                            .Weight = xlMedium
                        End With
        
                        .Interior.Color = RGB(192, 230, 245)
        
                    Else
                        .Interior.Color = RGB(255, 255, 255)
                    End If
                End With
            Next j
        Next i
        
        
        
        With ws.Range(Cells(12 + DataRow, 1 + colOffset), Cells(12 + DataRow, 9 + colOffset))
            .Interior.Color = RGB(68, 179, 225)
            .Font.Bold = True
            .Font.Color = RGB(255, 255, 255)
        End With
        
        ws.Range(Cells(12 + DataRow, 2 + colOffset), Cells(12 + DataRow, 4 + colOffset)).Merge
        ws.Range(Cells(12 + DataRow, 5 + colOffset), Cells(12 + DataRow, 7 + colOffset)).Merge
        
        With ws.Cells(12 + DataRow, 8 + colOffset)
            .value = "Total"
            .HorizontalAlignment = xlRight
            
            With .Borders(xlEdgeRight)
                .LineStyle = xlContinuous
                .ColorIndex = 0
                .TintAndShade = 0
                .Weight = xlHairline
            End With
        End With
        
        With ws.Cells(12 + DataRow, 9 + colOffset)
            criteriaRange = ws.Range(Cells(12, 1 + colOffset), Cells(12 + DataRow - 1, 9 + colOffset)).Address
            sumRange = ws.Range(Cells(12, 9 + colOffset), Cells(12 + DataRow - 1, 9 + colOffset)).Address

            .Formula = "=IF(SUMIF(" & criteriaRange & ",""UE""," & sumRange & ")<=0,""-"",SUMIF(" & criteriaRange & ",""UE""," & sumRange & "))"
            .HorizontalAlignment = xlRight
        End With
        
        With ws.Cells(8, 9 + colOffset)
            criteriaRange = ws.Range(Cells(12, 1 + colOffset), Cells(12 + DataRow - 1, 9 + colOffset)).Address
            sumRange = ws.Range(Cells(12, 9 + colOffset), Cells(12 + DataRow - 1, 9 + colOffset)).Address
            
            .Formula = "=SUMIF(" & criteriaRange & ",""UE""," & sumRange & ")"
        End With
        
        
        
        OutsideEdge ws.Range(Cells(12, 1 + colOffset), Cells(12 + DataRow, 9 + colOffset)), True
        OutsideEdge ws.Range(Cells(12 + DataRow, 1 + colOffset), Cells(12 + DataRow, 9 + colOffset))
    Next index
    
    
    
    With ws.PageSetup
        .LeftFooter = "&k525252 Campus HELHa" & Chr(10) & "Département Économique et Social"
        .RightFooter = "&k525252 &P / &N"
    End With
    
    
    
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
