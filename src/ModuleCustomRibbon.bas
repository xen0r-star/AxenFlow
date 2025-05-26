Attribute VB_Name = "ModuleCustomRibbon"
' Toutes les fonctions liées au bouton du ruban pour la catégorie AxenFlow

Sub LaunchApp(control As IRibbonControl)
    Main.Show vbModeless
End Sub

Sub ExportAllSheets(control As IRibbonControl)
    Dim newWorksheet As Workbook
    Dim ws As Worksheet
    Dim nameFile As String
    
    nameFile = Application.GetSaveAsFilename(FileFilter:="Fichiers Excel (*.xlsx), .*xlsx")
    
    Set newWorksheet = Workbooks.Add
    
    For Each ws In ThisWorkbook.Sheets
        sheetName = ws.name
            
        If sheetName <> "Etudiants" And sheetName <> "Enseignants" And sheetName <> "GrillePoints" And sheetName <> "IntervenantsMissions" And sheetName <> "Preview" Then
            ws.Copy After:=newWorksheet.Sheets(newWorksheet.Sheets.count)
        End If
    Next ws
    
    newWorksheet.SaveAs filename:=nameFile, FileFormat:=xlOpenXMLWorkbook
    newWorksheet.Close
    
    MsgBox "Vos données ont bien été exportées dans un fichier XLSX." & vbCrLf & _
           nameFile, _
           vbInformation + vbOKOnly, "Export Réussi"
End Sub

Sub DeleteAllSheets(control As IRibbonControl)
    Dim ws As Worksheet
    Dim sheetName As String
    Dim answer As Integer
    
    answer = MsgBox("Voulez-vous vraiment supprimer toutes les feuilles créées automatiquement dans ce document ?" & vbCrLf & _
                    "Cela ne supprimera pas les feuilles de données.", _
                    vbYesNo + vbQuestion + vbDefaultButton2, "Confirmation de suppression")
                    
    If answer = vbYes Then
        Application.DisplayAlerts = False
        
        For Each ws In ThisWorkbook.Sheets
            sheetName = ws.name
            
            If sheetName <> "Etudiants" And sheetName <> "Enseignants" And sheetName <> "GrillePoints" And sheetName <> "IntervenantsMissions" Then
                ws.Delete
            End If
        Next ws
        
        Application.DisplayAlerts = True
    End If
    
End Sub

Sub RelaunchApp(control As IRibbonControl)
    Unload Main
    Main.Show vbModeless
End Sub

Sub StopApp(control As IRibbonControl)
    Unload Main
End Sub

Sub ManageStudentPage(control As IRibbonControl)
    Main.Show vbModeless
    Main.MultiPageOnglet.value = 0
End Sub

Sub ManageTeacherPage(control As IRibbonControl)
    Main.Show vbModeless
    Main.MultiPageOnglet.value = 1
End Sub

Sub ManageMissionsPage(control As IRibbonControl)
    Main.Show vbModeless
    Main.MultiPageOnglet.value = 2
End Sub

Sub ManageNotePage(control As IRibbonControl)
    Main.Show vbModeless
    Main.MultiPageOnglet.value = 3
End Sub

Sub SendEmailPage(control As IRibbonControl)
    Main.Show vbModeless
    Main.MultiPageOnglet.value = 4
    Main.FrameEmailBody.ScrollTop = 0
End Sub

Sub ShowInfo(control As IRibbonControl)
    Main.Show vbModeless
    AdditionalInfo.Show
End Sub

Sub ShowHelp(control As IRibbonControl)
    ThisWorkbook.FollowHyperlink ("https://axenflow.web.app/")
End Sub

