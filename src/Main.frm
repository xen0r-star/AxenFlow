VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} Main 
   Caption         =   "AxenFlow"
   ClientHeight    =   8436.001
   ClientLeft      =   108
   ClientTop       =   456
   ClientWidth     =   15780
   OleObjectBlob   =   "Main.frx":0000
   ShowModal       =   0   'False
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' Interface principale qui gère les onglets Eleve, Enseignant, Mission, Notes et Email

' Déclaration d'une variable globale
Dim ALL_TEXTBOX As Collection
Dim ALL_CHECKBOX As Collection
Dim ALL_COMMANDBUTTON As Collection

Dim Student As Student
Dim Teacher As Teacher
Dim Mission As Mission
Dim Note As Note

Private Sub ButtonEmailClear_Click()
    ' Fonction pour vider tous les champs de configuration des e-mails
    
    Dim answer As Integer
    
    answer = MsgBox("Vous êtes sur le point de vider tous les champs. Cette action est irréversible." & vbCrLf & vbCrLf & _
                  "Voulez-vous vraiment continuer ?", vbExclamation + vbYesNo + vbDefaultButton2, "Confirmation de réinitialisation")

    
    If answer = vbYes Then
        Main.TextBoxEmailObject.text = ""
        Main.TextBoxEmailContent.text = ""
        Main.ComboBoxEmailOptionType.ListIndex = -1
        Main.TextBoxEmailOptionFileName.text = ""
        Main.ComboBoxEmailOptionFileFormat.ListIndex = -1
        Main.TextBoxEmailOptionFilePath.text = ""
        Main.ComboBoxEmailOptionFileData.ListIndex = -1
        Main.OptionButtonEmailOptionSendTo1.value = False
        Main.OptionButtonEmailOptionSendTo2.value = False
        Main.ComboBoxEmailOptionSendManageFile.ListIndex = -1
    End If
End Sub

Private Sub ButtonEmailExport_Click()
     ' Fonction pour exporter les paramètres de configuration des e-mails dans un fichier JSON

    Dim filePath As String
    Dim fileNum As Integer
    Dim jsonString As String
    Dim answer As Integer

    filePath = Application.GetSaveAsFilename(InitialFileName:="AxenFlowEmailSettings.json", FileFilter:="Fichiers JSON (*.json), *.json")
    
    If filePath = "" Or filePath = "Faux" Or filePath = "False" Then
        Exit Sub
    End If
    
    If Dir(filePath) <> "" Then
        answer = MsgBox("Un fichier avec ce nom existe déjà." & vbCrLf & _
                          "Voulez-vous le remplacer ?", vbExclamation + vbYesNo + vbDefaultButton2, "Confirmer l'enregistrement")
        
        If answer = vbNo Then Exit Sub
    End If
    
    jsonString = "{" & vbCrLf & _
                 """email_type"": """ & Me.ComboBoxEmailType.List(Me.ComboBoxEmailType.ListIndex) & """," & vbCrLf & _
                 """email_object"": """ & TextToJson(Main.TextBoxEmailObject.text) & """," & vbCrLf & _
                 """email_content"": """ & TextToJson(Main.TextBoxEmailContent.text) & """," & vbCrLf & _
                 """email_option_type"": """ & TextToJson(Main.ComboBoxEmailOptionType.text) & """," & vbCrLf & _
                 """email_option_file_name"": """ & TextToJson(Main.TextBoxEmailOptionFileName.text) & """," & vbCrLf & _
                 """email_option_file_format"": """ & TextToJson(Main.ComboBoxEmailOptionFileFormat.text) & """," & vbCrLf & _
                 """email_option_file_path"": """ & TextToJson(Main.TextBoxEmailOptionFilePath.text) & """," & vbCrLf & _
                 """email_option_file_data"": " & Main.ComboBoxEmailOptionFileData.ListIndex & "," & vbCrLf & _
                 """email_option_send_to"": " & IIf(Main.OptionButtonEmailOptionSendTo1.value, 1, IIf(Main.OptionButtonEmailOptionSendTo2.value, 2, 0)) & "," & vbCrLf & _
                 """email_option_send_manage_file"": """ & Main.ComboBoxEmailOptionSendManageFile.ListIndex & """" & vbCrLf & _
                 "}"

    fileNum = FreeFile
    Open filePath For Output As fileNum
    Print #fileNum, jsonString
    Close fileNum
    
End Sub

Private Sub ButtonEmailImport_Click()
    ' Fonction pour importer un fichier JSON contenant les paramètres de configuration des e-mails
    
    Dim filePath As String
    Dim textStream As Object
    Dim jsonString As String
    Dim text As String
    
    filePath = Application.GetOpenFilename(FileFilter:="Fichiers JSON (*.json), *.json", Title:="Sélectionner un fichier JSON")

    If filePath = "" Or filePath = "Faux" Or filePath = "False" Then
        Exit Sub
    End If
    
    Set textStream = CreateObject("Scripting.FileSystemObject").OpenTextFile(filePath, 1)
    jsonString = textStream.ReadAll
    textStream.Close
    
    jsonString = JsonToText(jsonString)
    
    
    On Error Resume Next
        text = ExtractValue(jsonString, "email_type")
        For i = 0 To Main.ComboBoxEmailType.ListCount - 1
            If Main.ComboBoxEmailType.List(i) = text Then
                Main.ComboBoxEmailType.ListIndex = i
                Exit For
            End If
        Next i
        
        Main.TextBoxEmailObject.text = ExtractValue(jsonString, "email_object")
        Main.TextBoxEmailContent.text = Replace(ExtractValue(jsonString, "email_content"), "\n", vbCrLf)
        Main.ComboBoxEmailOptionType.text = ExtractValue(jsonString, "email_option_type")
        Main.TextBoxEmailOptionFileName.text = ExtractValue(jsonString, "email_option_file_name")
        Main.ComboBoxEmailOptionFileFormat.text = ExtractValue(jsonString, "email_option_file_format")
        Main.TextBoxEmailOptionFilePath.text = ExtractValue(jsonString, "email_option_file_path")
        Main.ComboBoxEmailOptionFileData.ListIndex = ExtractValue(jsonString, "email_option_file_data")
        Main.OptionButtonEmailOptionSendTo1.value = IIf(ExtractValue(jsonString, "email_option_send_to") = 1, True, False)
        Main.OptionButtonEmailOptionSendTo2.value = IIf(ExtractValue(jsonString, "email_option_send_to") = 2, True, False)
        Main.ComboBoxEmailOptionSendManageFile.ListIndex = ExtractValue(jsonString, "email_option_send_manage_file")
        
    On Error GoTo 0
End Sub

Private Sub ButtonEmailSend_Click()
    ' Vérifie que tous les champs nécessaires sont remplis, génère un fichier en fonction des options,
    ' Et envoyer des e-mails avec fichiers générés a tout les étudiants, enseignants, ou missions
    ' Ou uniquement pour chaque destinataire sélectionné

    Dim Id As String
    Dim Email As String
    Dim name As String
    Dim firstName As String
    Dim textMission As String
    
    Dim text As String
    Dim lastRow As Integer
    Dim EmptyField As Boolean
    Dim PathFile As String
    Dim results As Boolean
    Dim EndTime As Double
    Dim selectedIndices As Collection
    
    Dim Collection As Controls
    
    
    If Trim(Main.TextBoxEmailObject.text) = "" Then
        Main.FrameEmailBody3.BackColor = &H3737B0
        Main.LabelEmailObject.BackColor = &H3737B0
        Main.TextBoxEmailObject.BackColor = &H3737B0
        EmptyField = True
    Else
        Main.FrameEmailBody3.BackColor = &H232411
        Main.LabelEmailObject.BackColor = &H232411
        Main.TextBoxEmailObject.BackColor = &H232411
    End If
    
    
    If Trim(Main.TextBoxEmailContent.text) = "" Then
        Main.TextBoxEmailContent.BackColor = &H3737B0
        EmptyField = True
    Else
        Main.TextBoxEmailContent.BackColor = &H232411
    End If
    
    
    If Main.ComboBoxEmailOptionType.ListIndex = -1 Then
        Main.ComboBoxEmailOptionType.BackColor = &H3737B0
        EmptyField = True
    Else
        Main.ComboBoxEmailOptionType.BackColor = &H4B4E2E
    End If
    
    
    If Trim(Main.TextBoxEmailOptionFileName.text) = "" Then
        Main.TextBoxEmailOptionFileName.BackColor = &H3737B0
        EmptyField = True
    Else
        Main.TextBoxEmailOptionFileName.BackColor = &H4B4E2E
    End If
    
    
    If Main.ComboBoxEmailOptionFileFormat.ListIndex = -1 Then
        Main.ComboBoxEmailOptionFileFormat.BackColor = &H3737B0
        EmptyField = True
    Else
        Main.ComboBoxEmailOptionFileFormat.BackColor = &H4B4E2E
    End If
    
    
    If Trim(Main.TextBoxEmailOptionFilePath.text) = "" Then
        Main.TextBoxEmailOptionFilePath.BackColor = &H3737B0
        EmptyField = True
    Else
        Main.TextBoxEmailOptionFilePath.BackColor = &H4B4E2E
    End If
    
    
    If Main.ComboBoxEmailOptionFileData.ListIndex = -1 Then
        Main.ComboBoxEmailOptionFileData.BackColor = &H3737B0
        EmptyField = True
    Else
        Main.ComboBoxEmailOptionFileData.BackColor = &H4B4E2E
    End If
    
    
    If Not (Main.OptionButtonEmailOptionSendTo1.value Or Main.OptionButtonEmailOptionSendTo2.value) Then
        Main.OptionButtonEmailOptionSendTo1.BackColor = &H3737B0
        Main.OptionButtonEmailOptionSendTo2.BackColor = &H3737B0
        EmptyField = True
    Else
        Main.OptionButtonEmailOptionSendTo1.BackColor = &H4B4E2E
        Main.OptionButtonEmailOptionSendTo2.BackColor = &H4B4E2E
    End If
    
    
    If Main.ComboBoxEmailOptionSendManageFile.ListIndex = -1 Then
        Main.ComboBoxEmailOptionSendManageFile.BackColor = &H3737B0
        EmptyField = True
    Else
        Main.ComboBoxEmailOptionSendManageFile.BackColor = &H4B4E2E
    End If

    
    
    Set selectedIndices = New Collection
    
    If EmptyField Then
        MsgBox "Veuillez remplir tous les champs!", vbExclamation, "Champs manquants"
    Else
        If Main.ComboBoxEmailType.ListIndex = 0 Then
            Set Collection = Me.FrameStudentBody.Controls
            Set selectedIndices = New Collection
            
            
            For i = 1 To Student.GetNumberElement
                If Not (Main.OptionButtonEmailOptionSendTo2.value And Not Collection("checkBox_" & i).value) Then
                    selectedIndices.Add i
                End If
            Next i
            
            
            If Main.OptionButtonEmailOptionSendTo1.value And selectedIndices.count <= 0 Then
                MsgBox "Aucune donnée n'a été trouvée dans les fichiers de données." & vbCrLf & _
                        "Veuillez vérifier le nom ou le contenu des feuilles et réessayer.", _
                        vbExclamation + vbOKOnly, "Aucune donnée trouvée"
                        
                Exit Sub

            ElseIf Main.OptionButtonEmailOptionSendTo2.value And selectedIndices.count <= 0 Then
                MsgBox "Aucune donnée n'a été sélectionnée dans les onglets." & vbCrLf & _
                        "Veuillez sélectionner une ou plusieurs données et réessayer.", _
                        vbExclamation + vbOKOnly, "Aucune sélection trouvée"
                        
                Exit Sub
            End If
            
            
            ProgressBar.clearInfo
            ProgressBar.Show vbModeless
            
            For i = 1 To selectedIndices.count
                If ProgressBar.GetCancelRequested Then
                    Unload ProgressBar
                    Exit Sub
                End If
            
                If Not (Main.OptionButtonEmailOptionSendTo2.value And Not Collection("checkBox_" & selectedIndices(i)).value) Then
                    Call ProgressBar.progress(i, selectedIndices.count)
                    
                    If i Mod 50 = 0 Then
                        ProgressBar.addInfo ("Pause de 5 seconds...")
                        
                        EndTime = Timer + 5
                        Do While Timer < EndTime
                            DoEvents
                        Loop
                    End If
                    
                    
                    Id = Student.GetWSStudent.Cells(selectedIndices(i) + 1, 1).value
                    Email = Student.GetWSStudent.Cells(selectedIndices(i) + 1, 5).value
                    name = Student.GetWSStudent.Cells(selectedIndices(i) + 1, 2).value
                    firstName = Student.GetWSStudent.Cells(selectedIndices(i) + 1, 3).value
                    
                    PathFile = ""
                    
                    
                    If Main.ComboBoxEmailOptionSendManageFile.ListIndex = 0 Then
                        ProgressBar.addInfo ("Génération du fichier pour " & name & " " & firstName & " en cours...")
                        
                        PathFile = GenerateRDN(Id, _
                                                IIf(Main.ComboBoxEmailOptionFileFormat.ListIndex = 1, "XLSX", "PDF"), _
                                                Main.TextBoxEmailOptionFileName.text, _
                                                Main.TextBoxEmailOptionFilePath.text, _
                                                IIf(Main.ComboBoxEmailOptionFileData.ListIndex = 1, "Minimum", "All"))
                    
                    ElseIf Main.ComboBoxEmailOptionSendManageFile.ListIndex = 1 Then
                        ProgressBar.addInfo ("Sélection du fichier pour " & name & " " & firstName & " en cours...")
                        
                        manageFile.SetId = Id
                        manageFile.SetEmail = Email
                        manageFile.SetName = name
                        manageFile.SetFirstName = firstName
                        
                        manageFile.Show
                        
                        
                        If manageFile.GetPath = "" Then
                            ProgressBar.addInfo ("Génération du fichier pour " & name & " " & firstName & " en cours...")
                            
                            PathFile = GenerateRDN(Id, _
                                                IIf(Main.ComboBoxEmailOptionFileFormat.ListIndex = 1, "XLSX", "PDF"), _
                                                Main.TextBoxEmailOptionFileName.text, _
                                                Main.TextBoxEmailOptionFilePath.text, _
                                                IIf(Main.ComboBoxEmailOptionFileData.ListIndex = 1, "Minimum", "All"))
                        Else
                            PathFile = manageFile.GetPath
                        End If
                        
                    ElseIf Main.ComboBoxEmailOptionSendManageFile.ListIndex = 2 Then
                        MsgBox "Hi"
                        Exit Sub
                    End If
                    
                    
                    If Not PathFile = "" Then
                        ProgressBar.addInfo ("Fichier généré avec succès pour " & name & " !")
                        ProgressBar.addInfo ("Envoi de l'e-mail à " & name & " (" & Email & ")...")
                        
                        results = SendEmail(Email, _
                                            ReplaceActionText(Main.TextBoxEmailObject.text, name, firstName), _
                                            ReplaceActionText(Main.TextBoxEmailContent.text, name, firstName), _
                                            PathFile, _
                                            IIf(Main.ComboBoxEmailOptionType.ListIndex = 0, "HTML", "TEXT"))
                                            
                        If results Then
                            ProgressBar.addInfo ("E-mail envoyé avec succès à " & Email & " !")
                        Else
                            ProgressBar.addInfo ("Échec de l'envoi du mail à " & Email & ". Vérifiez l'adresse.")
                        End If
                                            
                    Else
                        ProgressBar.addInfo ("Aucune donnée disponible pour " & name & " " & firstName & "!")
                    End If
                End If
            Next i
            
            Unload ProgressBar
            
            
        ElseIf Main.ComboBoxEmailType.ListIndex = 1 Then
            Set Collection = Me.FrameStudentBody.Controls
            Set selectedIndices = New Collection
            
            
            For i = 1 To Student.GetNumberElement
                If Not (Main.OptionButtonEmailOptionSendTo2.value And Not Collection("checkBox_" & i).value) Then
                    selectedIndices.Add i
                End If
            Next i
            
            
            If Main.OptionButtonEmailOptionSendTo1.value And selectedIndices.count <= 0 Then
                MsgBox "Aucune donnée n'a été trouvée dans les fichiers de données." & vbCrLf & _
                        "Veuillez vérifier le nom ou le contenu des feuilles et réessayer.", _
                        vbExclamation + vbOKOnly, "Aucune donnée trouvée"
                        
                Exit Sub

            ElseIf Main.OptionButtonEmailOptionSendTo2.value And selectedIndices.count <= 0 Then
                MsgBox "Aucune donnée n'a été sélectionnée dans les onglets." & vbCrLf & _
                        "Veuillez sélectionner une ou plusieurs données et réessayer.", _
                        vbExclamation + vbOKOnly, "Aucune sélection trouvée"
                        
                Exit Sub
            End If
            
            
            ProgressBar.clearInfo
            ProgressBar.Show vbModeless
            
            For i = 1 To selectedIndices.count
                If ProgressBar.GetCancelRequested Then
                    Unload ProgressBar
                    Exit Sub
                End If
                
                If Not (Main.OptionButtonEmailOptionSendTo2.value And Not Collection("checkBox_" & selectedIndices(i)).value) Then
                    Call ProgressBar.progress(i, selectedIndices.count)
                    
                    If i Mod 50 = 0 Then
                        ProgressBar.addInfo ("Pause de 5 seconds...")
                        
                        EndTime = Timer + 5
                        Do While Timer < EndTime
                            DoEvents
                        Loop
                    End If
                    
                    
                    Id = Student.GetWSStudent.Cells(selectedIndices(i) + 1, 1).value
                    Email = Student.GetWSStudent.Cells(selectedIndices(i) + 1, 5).value
                    name = Student.GetWSStudent.Cells(selectedIndices(i) + 1, 2).value
                    firstName = Student.GetWSStudent.Cells(selectedIndices(i) + 1, 3).value
                    
                    PathFile = ""
                    
                    
                    If Main.ComboBoxEmailOptionSendManageFile.ListIndex = 0 Then
                        ProgressBar.addInfo ("Génération du fichier pour " & name & " " & firstName & " en cours...")
                        
                        PathFile = GeneratePAE(Id, _
                                                IIf(Main.ComboBoxEmailOptionFileFormat.ListIndex = 1, "XLSX", "PDF"), _
                                                Main.TextBoxEmailOptionFileName.text, _
                                                Main.TextBoxEmailOptionFilePath.text, _
                                                IIf(Main.ComboBoxEmailOptionFileData.ListIndex = 1, "Minimum", "All"))
                    
                    ElseIf Main.ComboBoxEmailOptionSendManageFile.ListIndex = 1 Then
                        ProgressBar.addInfo ("Sélection du fichier pour " & name & " " & firstName & " en cours...")
                        
                        manageFile.SetId = Id
                        manageFile.SetEmail = Email
                        manageFile.SetName = name
                        manageFile.SetFirstName = firstName
                        
                        manageFile.Show
                        
                        
                        If manageFile.GetPath = "" Then
                            ProgressBar.addInfo ("Génération du fichier pour " & name & " " & firstName & " en cours...")
                            
                            PathFile = GeneratePAE(Id, _
                                                IIf(Main.ComboBoxEmailOptionFileFormat.ListIndex = 1, "XLSX", "PDF"), _
                                                Main.TextBoxEmailOptionFileName.text, _
                                                Main.TextBoxEmailOptionFilePath.text, _
                                                IIf(Main.ComboBoxEmailOptionFileData.ListIndex = 1, "Minimum", "All"))
                        Else
                            PathFile = manageFile.GetPath
                        End If
                        
                    ElseIf Main.ComboBoxEmailOptionSendManageFile.ListIndex = 2 Then
                        MsgBox "Hi"
                        Exit Sub
                    End If
                    
                    
                    If Not PathFile = "" Then
                        ProgressBar.addInfo ("Fichier généré avec succès pour " & name & " !")
                        ProgressBar.addInfo ("Envoi de l'e-mail à " & name & " (" & Email & ")...")
                        
                        results = SendEmail(Email, _
                                            ReplaceActionText(Main.TextBoxEmailObject.text, name, firstName), _
                                            ReplaceActionText(Main.TextBoxEmailContent.text, name, firstName), _
                                            PathFile, _
                                            IIf(Main.ComboBoxEmailOptionType.ListIndex = 0, "HTML", "TEXT"))
                                            
                        If results Then
                            ProgressBar.addInfo ("E-mail envoyé avec succès à " & Email & " !")
                        Else
                            ProgressBar.addInfo ("Échec de l'envoi du mail à " & Email & ". Vérifiez l'adresse.")
                        End If
                                            
                    Else
                        ProgressBar.addInfo ("Aucune donnée disponible pour " & name & " " & firstName & "!")
                    End If
                End If
            Next i
            
            Unload ProgressBar
            
            
        ElseIf Main.ComboBoxEmailType.ListIndex = 2 Then
            Set Collection = Me.FrameTeacherBody.Controls
            Set selectedIndices = New Collection
            
            
            For i = 1 To Teacher.GetNumberElement
                If Not (Main.OptionButtonEmailOptionSendTo2.value And Not Collection("checkBox_" & i).value) Then
                    selectedIndices.Add i
                End If
            Next i
            
            
            If Main.OptionButtonEmailOptionSendTo1.value And selectedIndices.count <= 0 Then
                MsgBox "Aucune donnée n'a été trouvée dans les fichiers de données." & vbCrLf & _
                        "Veuillez vérifier le nom ou le contenu des feuilles et réessayer.", _
                        vbExclamation + vbOKOnly, "Aucune donnée trouvée"
                        
                Exit Sub

            ElseIf Main.OptionButtonEmailOptionSendTo2.value And selectedIndices.count <= 0 Then
                MsgBox "Aucune donnée n'a été sélectionnée dans les onglets." & vbCrLf & _
                        "Veuillez sélectionner une ou plusieurs données et réessayer.", _
                        vbExclamation + vbOKOnly, "Aucune sélection trouvée"
                        
                Exit Sub
            End If
            
            
            ProgressBar.clearInfo
            ProgressBar.Show vbModeless
            
            For i = 1 To selectedIndices.count
                If ProgressBar.GetCancelRequested Then
                    Unload ProgressBar
                    Exit Sub
                End If
                
                If Not (Main.OptionButtonEmailOptionSendTo2.value And Not Collection("checkBox_" & selectedIndices(i)).value) Then
                    Call ProgressBar.progress(i, selectedIndices.count)
                    
                    If i Mod 50 = 0 Then
                        ProgressBar.addInfo ("Pause de 5 seconds...")
                        
                        EndTime = Timer + 5
                        Do While Timer < EndTime
                            DoEvents
                        Loop
                    End If
                    
                    
                    Id = Teacher.GetWSTeacher.Cells(selectedIndices(i) + 1, 1).value
                    Email = Teacher.GetWSTeacher.Cells(selectedIndices(i) + 1, 4).value
                    name = Teacher.GetWSTeacher.Cells(selectedIndices(i) + 1, 2).value
                    firstName = Teacher.GetWSTeacher.Cells(selectedIndices(i) + 1, 3).value
                    
                    PathFile = ""
                    
                    
                    If Main.ComboBoxEmailOptionSendManageFile.ListIndex = 0 Then
                        ProgressBar.addInfo ("Génération du fichier pour " & name & " " & firstName & " en cours...")
                        
                        PathFile = GenerateATB(Id, _
                                                IIf(Main.ComboBoxEmailOptionFileFormat.ListIndex = 1, "XLSX", "PDF"), _
                                                Main.TextBoxEmailOptionFileName.text, _
                                                Main.TextBoxEmailOptionFilePath.text)
                    
                    ElseIf Main.ComboBoxEmailOptionSendManageFile.ListIndex = 1 Then
                        ProgressBar.addInfo ("Sélection du fichier pour " & name & " " & firstName & " en cours...")
                        
                        manageFile.SetId = Id
                        manageFile.SetEmail = Email
                        manageFile.SetName = name
                        manageFile.SetFirstName = firstName
                        
                        manageFile.Show
                        
                        
                        If manageFile.GetPath = "" Then
                            ProgressBar.addInfo ("Génération du fichier pour " & name & " " & firstName & " en cours...")
                            
                            PathFile = GenerateATB(Id, _
                                                IIf(Main.ComboBoxEmailOptionFileFormat.ListIndex = 1, "XLSX", "PDF"), _
                                                Main.TextBoxEmailOptionFileName.text, _
                                                Main.TextBoxEmailOptionFilePath.text)
                        Else
                            PathFile = manageFile.GetPath
                        End If
                    
                    ElseIf Main.ComboBoxEmailOptionSendManageFile.ListIndex = 2 Then
                        MsgBox "Hi"
                        Exit Sub
                    End If
                    
                    
                    If Not PathFile = "" Then
                        ProgressBar.addInfo ("Fichier généré avec succès pour " & name & " !")
                        ProgressBar.addInfo ("Envoi de l'e-mail à " & name & " (" & Email & ")...")
                        
                        
                        
                        lastRow = Mission.GetWSMission.Cells(Mission.GetWSMission.Rows.count, 1).End(xlUp).row
                        
                        textMission = ""
                        For j = 2 To lastRow
                            If Mission.GetWSMission.Cells(j, "B") = Id Then
                                textMission = textMission & "- " & Mission.GetWSMission.Cells(j, "C") & vbCrLf
                            End If
                        Next j
                        
                        Set regex = CreateObject("VBScript.RegExp")
                        
                        regex.IgnoreCase = True
                        regex.Global = True
                        
                        regex.Pattern = "\[(mission|Missions|attribution|attributions)\]"
                        text = regex.Replace(Main.TextBoxEmailContent.text, textMission)
                        
                        
                        
                        results = SendEmail(Email, _
                                            ReplaceActionText(Main.TextBoxEmailObject.text, name, firstName), _
                                            ReplaceActionText(text, name, firstName), _
                                            PathFile, _
                                            IIf(Main.ComboBoxEmailOptionType.ListIndex = 0, "HTML", "TEXT"))
                                            
                        If results Then
                            ProgressBar.addInfo ("E-mail envoyé avec succès à " & Email & " !")
                        Else
                            ProgressBar.addInfo ("Échec de l'envoi du mail à " & Email & ". Vérifiez l'adresse.")
                        End If
                                            
                    Else
                        ProgressBar.addInfo ("Aucune donnée disponible pour " & name & " " & firstName & "!")
                    End If
                End If
            Next i
            
            Unload ProgressBar
        End If
    End If
End Sub

Private Sub ButtonEmailText1_Click()
    ' Insère le texte d'action "[Nom]" dans le contenu du courriel
    
    actionText "[Nom]", Me.TextBoxEmailContent
End Sub

Private Sub ButtonEmailText2_Click()
    ' Insère le texte d'action "[Prénom]" dans le contenu du courriel

    actionText "[Prénom]", Me.TextBoxEmailContent
End Sub

Private Sub ButtonEmailText3_Click()
    ' Insère le texte d'action "[Classe]" dans le contenu du courriel

    actionText "[Année]", Me.TextBoxEmailContent
End Sub

Private Sub ButtonEmailText4_Click()
    ' Insère le texte d'action "[Missions]" dans le contenu du courriel

    actionText "[Missions]", Me.TextBoxEmailContent
End Sub

Private Sub ButtonEmailView_Click()
    ' Affiche une prévisualisation de l'e-mail avec la configuration sélectionnée
    
    Dim PathFile As String
    Dim results As Boolean
    Dim Id As String
    Dim Email As String
    Dim name As String
    Dim firstName As String
    Dim Collection As Controls
    
    
    If Main.ComboBoxEmailType.ListIndex = 0 Then
        Set Collection = Me.FrameStudentBody.Controls
        
        For i = 1 To Student.GetNumberElement
            If Not (Main.OptionButtonEmailOptionSendTo2.value And Not Collection("checkBox_" & i).value) Then
                Id = Student.GetWSStudent.Cells(i + 1, 1).value
                Email = Student.GetWSStudent.Cells(i + 1, 5).value
                name = Student.GetWSStudent.Cells(i + 1, 2).value
                firstName = Student.GetWSStudent.Cells(i + 1, 3).value
                
                PathFile = GenerateRDN(Id, _
                    IIf(Main.ComboBoxEmailOptionFileFormat.ListIndex = 1, "XLSX", "PDF"), _
                    Main.TextBoxEmailOptionFileName.text & "_Preview", _
                    Main.TextBoxEmailOptionFilePath.text, _
                    IIf(Main.ComboBoxEmailOptionFileData.ListIndex = 1, "Minimum", "All"), True)
                
                If PathFile <> "" Then
                    Exit For
                End If
            End If
        Next i
        
    ElseIf Main.ComboBoxEmailType.ListIndex = 1 Then
        Set Collection = Me.FrameStudentBody.Controls
        
        For i = 1 To Student.GetNumberElement
            If Not (Main.OptionButtonEmailOptionSendTo2.value And Not Collection("checkBox_" & i).value) Then
                Id = Student.GetWSStudent.Cells(i + 1, 1).value
                Email = Student.GetWSStudent.Cells(i + 1, 5).value
                name = Student.GetWSStudent.Cells(i + 1, 2).value
                firstName = Student.GetWSStudent.Cells(i + 1, 3).value
                
                PathFile = GeneratePAE(Id, _
                    IIf(Main.ComboBoxEmailOptionFileFormat.ListIndex = 1, "XLSX", "PDF"), _
                    Main.TextBoxEmailOptionFileName.text & "_Preview", _
                    Main.TextBoxEmailOptionFilePath.text, _
                    IIf(Main.ComboBoxEmailOptionFileData.ListIndex = 1, "Minimum", "All"), True)
                
                If PathFile <> "" Then
                    Exit For
                End If
            End If
        Next i
        
    ElseIf Main.ComboBoxEmailType.ListIndex = 2 Then
        Set Collection = Me.FrameTeacherBody.Controls
        
        For i = 1 To Teacher.GetNumberElement
            If Not (Main.OptionButtonEmailOptionSendTo2.value And Not Collection("checkBox_" & i).value) Then
                Id = Teacher.GetWSTeacher.Cells(i + 1, 1).value
                Email = Teacher.GetWSTeacher.Cells(i + 1, 4).value
                name = Teacher.GetWSTeacher.Cells(i + 1, 2).value
                firstName = Teacher.GetWSTeacher.Cells(i + 1, 3).value
                
                PathFile = GenerateATB(Id, _
                    IIf(Main.ComboBoxEmailOptionFileFormat.ListIndex = 1, "XLSX", "PDF"), _
                    Main.TextBoxEmailOptionFileName.text & "_Preview", _
                    Main.TextBoxEmailOptionFilePath.text, True)
                    
                If PathFile <> "" Then
                    Exit For
                End If
            End If
        Next i
    End If
    
    If PathFile <> "" Then
        MsgBox "Ceci est un e-mail de prévisualisation. Il ne sera pas envoyé." & _
                "Il permet seulement de voir à quoi ressemblera l'email avant d'être envoyé.", _
                vbInformation + vbOKOnly + vbDefaultButton1, "Prévisualisation E-mail"


        results = SendEmail(Email, _
                    ReplaceActionText(Main.TextBoxEmailObject.text, name, firstName), _
                    ReplaceActionText(Main.TextBoxEmailContent.text, name, firstName), _
                    PathFile, _
                    IIf(Main.ComboBoxEmailOptionType.ListIndex = 0, "HTML", "TEXT"), True)
        
        If Not results Then
            MsgBox "Erreur lors de la prévisualisation de l'e-mail. Veuillez vérifier les données et réessayer.", _
                    vbCritical + vbOKOnly + vbDefaultButton1, "Erreur de Prévisualisation"
       End If
    
    Else
        MsgBox "Il n'y a pas assez d'informations dans le document pour permettre de créer une prévisualisation." & _
                vbCrLf & "Veuillez vérifier les données avant de recommencer.", _
                vbInformation + vbOKOnly + vbDefaultButton1, "Vérification Requise"
    End If
End Sub

Private Sub ComboBoxEmailOptionSendManageFile_Change()
    Static largerBlock As Boolean
    
    If Main.ComboBoxEmailOptionSendManageFile.ListIndex = 2 Then
        If largerBlock Then Exit Sub
        
        Main.FrameEmailOptionSend.Height = 240
        Main.FrameEmailBody.ScrollHeight = Main.FrameEmailBody.ScrollHeight + 90
        
        Main.ButtonEmailClear.Top = Main.ButtonEmailClear.Top + 90
        Main.ButtonEmailImport.Top = Main.ButtonEmailImport.Top + 90
        Main.ButtonEmailExport.Top = Main.ButtonEmailExport.Top + 90
        Main.ButtonEmailView.Top = Main.ButtonEmailView.Top + 90
        Main.ButtonEmailSend.Top = Main.ButtonEmailSend.Top + 90
        
        Main.LabelEmailOptionSend3.Visible = True
        Main.LabelEmailOptionSend4.Visible = True
        Main.TextBoxEmailOptionSendNameGeneric.Visible = True
        Main.TextBoxEmailOptionSendPathFolder.Visible = True
        
        ' Update element display inside frame
        If Main.FrameEmailBody.ScrollTop <= 0 Then
            Main.FrameEmailBody.ScrollTop = Main.FrameEmailBody.ScrollTop + 1
        Else
            Main.FrameEmailBody.ScrollTop = Main.FrameEmailBody.ScrollTop - 1
        End If
        
        largerBlock = True
        
    Else
        If Not largerBlock Then Exit Sub
        
        Main.FrameEmailOptionSend.Height = 150
        Main.FrameEmailBody.ScrollHeight = Main.FrameEmailBody.ScrollHeight - 90
        
        Main.ButtonEmailClear.Top = Main.ButtonEmailClear.Top - 90
        Main.ButtonEmailImport.Top = Main.ButtonEmailImport.Top - 90
        Main.ButtonEmailExport.Top = Main.ButtonEmailExport.Top - 90
        Main.ButtonEmailView.Top = Main.ButtonEmailView.Top - 90
        Main.ButtonEmailSend.Top = Main.ButtonEmailSend.Top - 90
        
        Main.LabelEmailOptionSend3.Visible = False
        Main.LabelEmailOptionSend4.Visible = False
        Main.TextBoxEmailOptionSendNameGeneric.Visible = False
        Main.TextBoxEmailOptionSendPathFolder.Visible = False
        
        ' Update element display inside frame
        If Main.FrameEmailBody.ScrollTop <= 0 Then
            Main.FrameEmailBody.ScrollTop = Main.FrameEmailBody.ScrollTop + 1
        Else
            Main.FrameEmailBody.ScrollTop = Main.FrameEmailBody.ScrollTop - 1
        End If
        
        largerBlock = False
    End If
End Sub

Private Sub ImageInfo_Click()
    ' Affiche les informations complémentaires
    
    AdditionalInfo.Show
End Sub

Private Sub ImageHelp_Click()
    ' Ouvre le site web d'aide du projet
    
    ThisWorkbook.FollowHyperlink ("https://axenflow.web.app/")
End Sub

Private Sub ImageExit_Click()
    ' Ferme l'application
    
    Unload Me
End Sub

Private Sub ComboBoxEmailType_Change()
    ' Complétion pour mettre le bon élément sélectionné et
    ' met à jour le contenu du courriel et du fichier joint selon le type sélectionné

    ' Completion
    Dim OtherElement As Object
    Set OtherElement = CreateObject("Scripting.Dictionary")

    OtherElement.Add "rdn", "Relevé de Notes"
    OtherElement.Add "pae", "Programme Annuel de l'Etudiant"
    OtherElement.Add "mission", "Attribution"

    If OtherElement.Exists(LCase(ComboBoxEmailType.text)) Then
        ComboBoxEmailType.text = OtherElement(LCase(ComboBoxEmailType.text))
    End If
    
    
    
    ButtonEmailText4.Visible = False
    
    Select Case ComboBoxEmailType.value
        Case "Relevé de Notes"
            TextBoxEmailTo.value = "laxxxxxx@student.helha.be"
            TextBoxEmailObject.value = "Votre Relevé de Notes pour l’Année Académique [Année]"
            TextBoxEmailContent.value = "Cher(e) [Prénom] [Nom]," & vbCrLf & vbCrLf & _
                                        "Veuillez trouver en pièce jointe votre relevé de notes pour l’année académique [Année]." & vbCrLf & vbCrLf & _
                                        "Nous vous invitons à vérifier attentivement les informations contenues dans ce relevé. En cas d’erreur ou de question, n’hésitez pas à nous contacter à l’adresse suivante: secretariat.eco.mons@helha.be" & vbCrLf & vbCrLf & _
                                        "Cordialement,"
            TextBoxEmailOptionFileName.value = "ReleveDeNotes_[DATE]_[NAME]_[SURNAME]"

        Case "Programme Annuel de l'Etudiant"
            TextBoxEmailTo.value = "laxxxxxx@student.helha.be"
            TextBoxEmailObject.value = "Votre PAE pour l’Année Académique [Année]"
            TextBoxEmailContent.value = "Cher(e) [Prénom] [Nom]," & vbCrLf & vbCrLf & _
                                        "Veuillez trouver en pièce jointe votre PAE pour l’année académique [Année]." & vbCrLf & vbCrLf & _
                                        "Nous vous invitons à vérifier attentivement les informations contenues dans ce relevé. En cas d’erreur ou de question, n’hésitez pas à nous contacter à l’adresse suivante: secretariat.eco.mons@helha.be" & vbCrLf & vbCrLf & _
                                        "Cordialement,"
            TextBoxEmailOptionFileName.value = "PAE_[DATE]_[NAME]_[SURNAME]"
            
        Case "Attribution"
            TextBoxEmailTo.value = "prenom.nom@helha.be"
            TextBoxEmailObject.value = "Attribution de vos Missions pour l'Année Académique [Année]"
            TextBoxEmailContent.value = "Cher(e) [Prénom] [Nom]," & vbCrLf & vbCrLf & _
                                        "Nous vous informons des missions qui vous ont été attribuées pour l’année académique [Année]. Veuillez trouver en pièce jointe la liste des missions que vous devez accomplir : " & vbCrLf & _
                                        "[Missions]" & vbCrLf & vbCrLf & _
                                        "Nous vous invitons à vérifier attentivement les informations contenues dans ce relevé. En cas d’erreur ou de question, n’hésitez pas à nous contacter à l’adresse suivante: secretariat.eco.mons@helha.be" & vbCrLf & vbCrLf & _
                                        "Cordialement,"
            TextBoxEmailOptionFileName.value = "[SURNAME] [NAME]"
            ButtonEmailText4.Visible = True
    End Select
    
    Main.FrameEmailBody3.BackColor = &H232411
    Main.LabelEmailObject.BackColor = &H232411
    Main.TextBoxEmailObject.BackColor = &H232411
    Main.TextBoxEmailContent.BackColor = &H232411
    Main.ComboBoxEmailOptionType.BackColor = &H4B4E2E
    Main.TextBoxEmailOptionFileName.BackColor = &H4B4E2E
    Main.ComboBoxEmailOptionFileFormat.BackColor = &H4B4E2E
    Main.TextBoxEmailOptionFilePath.BackColor = &H4B4E2E
    Main.OptionButtonEmailOptionSendTo1.BackColor = &H4B4E2E
    Main.OptionButtonEmailOptionSendTo2.BackColor = &H4B4E2E
    Main.ComboBoxEmailOptionSendManageFile.BackColor = &H4B4E2E
End Sub

Private Sub ImageStudentAdd_Click()
    ' Ajoute un nouvel élément à la liste et met à jour l'affichage des éléments
    
    Student.SetNumberElement = Student.GetNumberElement + 1
    ScrollBarStudent.max = Application.WorksheetFunction.max(1, Student.GetNumberElement + 1 - 14) ' Min a 1
    ScrollBarStudent.value = ScrollBarStudent.max
    
    Me.FrameStudentHeader.Controls("LabelStudentTitle").Caption = CStr(Student.GetNumberElement) & " élèves"
    
    Call Student.AddElement(Student.GetNumberElement + 1, False)
    Student.UpdateElement (ScrollBarStudent.value)
End Sub

Private Sub ImageStudentSave_Click()
    ' Sauvegarde tous les éléments dans la feuille Excel
    
    Dim answer As Integer
    
    answer = MsgBox("Vous êtes sur le point de sauvegarder vos modifications." & vbNewLine & _
                 "Cette action appliquera les modifications à la feuille Excel """ & Student.GetWSStudent.name & """ et sera irréversible." & vbNewLine & vbNewLine & _
                 "Voulez-vous continuer ?", vbExclamation + vbYesNo + vbDefaultButton2, "Confirmation de sauvegarde")

    If answer = vbYes Then
        Student.SaveElement
    End If
End Sub

Private Sub ImageStudentTrash_Click()
    ' Supprime les éléments sélectionnés par l'utilisateur dans le FrameStudentBody
    
    Dim control As MSForms.CheckBox
    Dim answer As Integer
    Dim elementNumber() As Integer
    Dim n As Integer
    
    n = 0
    For i = Student.GetNumberElement To 1 Step -1
        Set control = Me.FrameStudentBody.Controls("checkBox_" & i)

        If control.value = True Then
            ReDim Preserve elementNumber(Student.GetNumberElement - 1)
            elementNumber(n) = i
            n = n + 1
        End If
    Next i
    
    answer = MsgBox("Vous êtes sur le point de supprimer " & n & " élément(s)." & vbNewLine & _
                 "Cette action est irréversible." & vbNewLine & vbNewLine & _
                 "Voulez-vous continuer ?", vbYesNo + vbCritical + vbDefaultButton2, "Confirmation de suppression")
    
    If answer = vbYes Then
        If n > 0 Then
            For i = 0 To n - 1
                Student.TrashElement (elementNumber(i))
            Next i
            
            ' Limine min a 1
            ScrollBarStudent.max = Application.WorksheetFunction.max(1, Student.GetNumberElement + 1 - 14)
            
            Student.UpdateElement (ScrollBarStudent.value)
            
            Me.FrameStudentHeader.Controls("LabelStudentTitle").Caption = CStr(Student.GetNumberElement) & " élèves"
            Me.FrameStudentHeader.Controls("LabelStudentSubtitle").Caption = "0 sélectionné"
        End If
    End If
End Sub

Private Sub CheckBoxStudentAll_Click()
    ' Coche ou décoche toutes les cases à cocher dans le FrameStudentBody

    Dim Collection As Controls
    Set Collection = Me.FrameStudentBody.Controls
    
    For i = 1 To Student.GetNumberElement
        Collection("checkBox_" & i).value = CheckBoxStudentAll.value
    Next i
End Sub

Private Sub ImageTeacherAdd_Click()
    ' Ajoute un nouvel élément à la liste et met à jour l'affichage des éléments
    
    Teacher.SetNumberElement = Teacher.GetNumberElement + 1
    ScrollBarTeacher.max = Application.WorksheetFunction.max(1, Teacher.GetNumberElement + 1 - 14) ' Min a 1
    ScrollBarTeacher.value = ScrollBarTeacher.max
    
    Me.FrameTeacherHeader.Controls("LabelTeacherTitle").Caption = CStr(Teacher.GetNumberElement) & " enseignants"
    
    Call Teacher.AddElement(Teacher.GetNumberElement + 1, False)
    Teacher.UpdateElement (ScrollBarTeacher.value)
End Sub

Private Sub ImageTeacherSave_Click()
    ' Sauvegarde tous les éléments dans la feuille Excel

    Dim answer As Integer
    
    answer = MsgBox("Vous êtes sur le point de sauvegarder vos modifications." & vbNewLine & _
                 "Cette action appliquera les modifications à la feuille Excel """ & Teacher.GetWSTeacher.name & """ et sera irréversible." & vbNewLine & vbNewLine & _
                 "Voulez-vous continuer ?", vbExclamation + vbYesNo + vbDefaultButton2, "Confirmation de sauvegarde")

    If answer = vbYes Then
        Teacher.SaveElement
    End If
End Sub

Private Sub ImageTeacherTrash_Click()
    ' Supprime les éléments sélectionnés par l'utilisateur dans le FrameTeacherBody
    
    Dim control As MSForms.CheckBox
    Dim answer As Integer
    Dim elementNumber() As Integer
    Dim n As Integer
    
    n = 0
    For i = Teacher.GetNumberElement To 1 Step -1
        Set control = Me.FrameTeacherBody.Controls("checkBox_" & i)

        If control.value = True Then
            ReDim Preserve elementNumber(Teacher.GetNumberElement - 1)
            elementNumber(n) = i
            n = n + 1
        End If
    Next i
    
    answer = MsgBox("Vous êtes sur le point de supprimer " & n & " élément(s)." & vbNewLine & _
                 "Cette action est irréversible." & vbNewLine & vbNewLine & _
                 "Voulez-vous continuer ?", vbYesNo + vbCritical + vbDefaultButton2, "Confirmation de suppression")
    
    If answer = vbYes Then
        If n > 0 Then
            For i = 0 To n - 1
                Teacher.TrashElement (elementNumber(i))
            Next i
            
            ' Limine min a 1
            ScrollBarTeacher.max = Application.WorksheetFunction.max(1, Teacher.GetNumberElement + 1 - 14)
            
            Teacher.UpdateElement (ScrollBarTeacher.value)
            
            Me.FrameTeacherHeader.Controls("LabelTeacherTitle").Caption = CStr(Teacher.GetNumberElement) & " enseignants"
            Me.FrameTeacherHeader.Controls("LabelTeacherSubtitle").Caption = "0 sélectionné"
        End If
    End If
End Sub

Private Sub CheckBoxTeacherAll_Click()
    ' Coche ou décoche toutes les cases à cocher dans le FrameTeacherBody
    
    Dim Collection As Controls
    Set Collection = Me.FrameTeacherBody.Controls
    
    For i = 1 To Teacher.GetNumberElement
        Collection("checkBox_" & i).value = CheckBoxTeacherAll.value
    Next i
End Sub

Private Sub ImageMissionAdd_Click()
    ' Ajoute un nouvel élément à la liste et met à jour l'affichage des éléments
    
    Mission.SetNumberElement = Mission.GetNumberElement + 1
    ScrollBarMission.max = Application.WorksheetFunction.max(1, Mission.GetNumberElement + 1 - 14) ' Min a 1
    ScrollBarMission.value = ScrollBarMission.max
    
    Me.FrameMissionHeader.Controls("LabelMissionTitle").Caption = CStr(Mission.GetNumberElement) & " missions"
    
    Call Mission.AddElement(Mission.GetNumberElement + 1, False)
    Mission.UpdateElement (ScrollBarMission.value)
End Sub

Private Sub ImageMissionSave_Click()
    ' Sauvegarde tous les éléments dans la feuille Excel

    Dim answer As Integer
    
    answer = MsgBox("Vous êtes sur le point de sauvegarder vos modifications." & vbNewLine & _
                 "Cette action appliquera les modifications à la feuille Excel """ & Mission.GetWSMission.name & """ et sera irréversible." & vbNewLine & vbNewLine & _
                 "Voulez-vous continuer ?", vbExclamation + vbYesNo + vbDefaultButton2, "Confirmation de sauvegarde")

    If answer = vbYes Then
        Mission.SaveElement
    End If
End Sub

Private Sub ImageMissionTrash_Click()
    ' Supprime les éléments sélectionnés par l'utilisateur dans le FrameMissionBody
    
    Dim control As MSForms.CheckBox
    Dim answer As Integer
    Dim elementNumber() As Integer
    Dim n As Integer
    
    n = 0
    For i = Mission.GetNumberElement To 1 Step -1
        Set control = Me.FrameMissionBody.Controls("checkBox_" & i)

        If control.value = True Then
            ReDim Preserve elementNumber(Mission.GetNumberElement - 1)
            elementNumber(n) = i
            n = n + 1
        End If
    Next i
    
    answer = MsgBox("Vous êtes sur le point de supprimer " & n & " élément(s)." & vbNewLine & _
                 "Cette action est irréversible." & vbNewLine & vbNewLine & _
                 "Voulez-vous continuer ?", vbYesNo + vbCritical + vbDefaultButton2, "Confirmation de suppression")
    
    If answer = vbYes Then
        If n > 0 Then
            For i = 0 To n - 1
                Mission.TrashElement (elementNumber(i))
            Next i
            
            ' Limine min a 1
            ScrollBarMission.max = Application.WorksheetFunction.max(1, Mission.GetNumberElement + 1 - 14)
            
            Mission.UpdateElement (ScrollBarMission.value)
            
            Me.FrameMissionHeader.Controls("LabelMissionTitle").Caption = CStr(Mission.GetNumberElement) & " mission"
            Me.FrameMissionHeader.Controls("LabelMissionSubtitle").Caption = "0 sélectionné"
        End If
    End If
End Sub

Private Sub CheckBoxMissionAll_Click()
    ' Coche ou décoche toutes les cases à cocher dans le FrameMissionBody
    
    Dim Collection As Controls
    Set Collection = Me.FrameMissionBody.Controls
    
    For i = 1 To Mission.GetNumberElement
        Collection("checkBox_" & i).value = CheckBoxMissionAll.value
    Next i
End Sub

Private Sub ImageNoteAdd_Click()
    ' Ajoute un nouvel élément à la liste et met à jour l'affichage des éléments
    
    Note.SetNumberElement = Note.GetNumberElement + 1
    ScrollBarNote.max = Application.WorksheetFunction.max(1, Note.GetNumberElement + 1 - 14) ' Min a 1
    ScrollBarNote.value = ScrollBarNote.max
    
    Me.FrameNoteHeader.Controls("LabelNoteTitle").Caption = CStr(Note.GetNumberElement) & " notes"
    
    Call Note.AddElement(Note.GetNumberElement + 1, False)
    Note.UpdateElement (ScrollBarNote.value)
End Sub

Private Sub ImageNoteSave_Click()
    ' Sauvegarde tous les éléments dans la feuille Excel
    
    Dim answer As Integer
    
    answer = MsgBox("Vous êtes sur le point de sauvegarder vos modifications." & vbNewLine & _
                 "Cette action appliquera les modifications à la feuille Excel """ & Note.GetWSNote.name & """ et sera irréversible." & vbNewLine & vbNewLine & _
                 "Voulez-vous continuer ?", vbExclamation + vbYesNo + vbDefaultButton2, "Confirmation de sauvegarde")

    If answer = vbYes Then
        Note.SaveElement
    End If
End Sub

Private Sub ImageNoteTrash_Click()
    ' Supprime les éléments sélectionnés par l'utilisateur dans le FrameNoteBody
    
    Dim control As MSForms.CheckBox
    Dim answer As Integer
    Dim elementNumber() As Integer
    Dim n As Integer
    
    n = 0
    For i = Note.GetNumberElement To 1 Step -1
        Set control = Me.FrameNoteBody.Controls("checkBox_" & i)

        If control.value = True Then
            ReDim Preserve elementNumber(Note.GetNumberElement - 1)
            elementNumber(n) = i
            n = n + 1
        End If
    Next i
    
    answer = MsgBox("Vous êtes sur le point de supprimer " & n & " élément(s)." & vbNewLine & _
                 "Cette action est irréversible." & vbNewLine & vbNewLine & _
                 "Voulez-vous continuer ?", vbYesNo + vbCritical + vbDefaultButton2, "Confirmation de suppression")
    
    If answer = vbYes Then
        If n > 0 Then
            For i = 0 To n - 1
                Note.TrashElement (elementNumber(i))
            Next i
            
            ' Limine min a 1
            ScrollBarNote.max = Application.WorksheetFunction.max(1, Note.GetNumberElement + 1 - 14)
            
            Note.UpdateElement (ScrollBarNote.value)
            
            Me.FrameNoteHeader.Controls("LabelNoteTitle").Caption = CStr(Note.GetNumberElement) & " note"
            Me.FrameNoteHeader.Controls("LabelNoteSubtitle").Caption = "0 sélectionné"
        End If
    End If
End Sub

Private Sub CheckBoxNoteAll_Click()
    ' Coche ou décoche toutes les cases à cocher dans le FrameNoteBody
    
    Dim Collection As Controls
    Set Collection = Me.FrameNoteBody.Controls
    
    For i = 1 To Note.GetNumberElement
        Collection("checkBox_" & i).value = CheckBoxNoteAll.value
    Next i
End Sub

Private Sub FrameStudent_Click()
    ' Change l'onglet actif
    
    MultiPageOnglet.value = 0
End Sub

Private Sub LabelStudent_Click()
    ' Change l'onglet actif
    
    MultiPageOnglet.value = 0
End Sub

Private Sub FrameTeacher_Click()
    ' Change l'onglet actif
    
    MultiPageOnglet.value = 1
End Sub

Private Sub LabelTeacher_Click()
    ' Change l'onglet actif
    
    MultiPageOnglet.value = 1
End Sub

Private Sub FrameMission_Click()
    ' Change l'onglet actif
    
    MultiPageOnglet.value = 2
End Sub

Private Sub LabelMission_Click()
    ' Change l'onglet actif
    
    MultiPageOnglet.value = 2
End Sub

Private Sub FrameNote_Click()
    ' Change l'onglet actif
    
    MultiPageOnglet.value = 3
End Sub

Private Sub LabelNote_Click()
    ' Change l'onglet actif
    
    MultiPageOnglet.value = 3
End Sub

Private Sub FrameEmail_Click()
    ' Change l'onglet actif
    
    MultiPageOnglet.value = 4
    FrameEmailBody.ScrollTop = 0
End Sub

Private Sub LabelEmail_Click()
    ' Change l'onglet actif
    
    MultiPageOnglet.value = 4
    FrameEmailBody.ScrollTop = 0
End Sub

Private Sub ScrollBarMission_Change()
    ' Met à jour l'affichage des éléments en fonction de la position du ScrollBarMission
    
    Mission.UpdateElement (ScrollBarMission.value)
End Sub

Private Sub ScrollBarMission_Scroll()
    ' Met à jour l'affichage des éléments en fonction de la position du ScrollBarMission
    
    Mission.UpdateElement (ScrollBarMission.value)
End Sub

Private Sub ScrollBarStudent_Change()
    ' Met à jour l'affichage des éléments en fonction de la position du ScrollBarStudent
    
    Student.UpdateElement (ScrollBarStudent.value)
End Sub

Private Sub ScrollBarStudent_Scroll()
    ' Met à jour l'affichage des éléments en fonction de la position du ScrollBarStudent

    Student.UpdateElement (ScrollBarStudent.value)
End Sub

Private Sub ScrollBarTeacher_Change()
    ' Met à jour l'affichage des éléments en fonction de la position du ScrollBarTeacher
    
    Teacher.UpdateElement (ScrollBarTeacher.value)
End Sub

Private Sub ScrollBarTeacher_Scroll()
    ' Met à jour l'affichage des éléments en fonction de la position du ScrollBarTeacher

    Teacher.UpdateElement (ScrollBarTeacher.value)
End Sub

Private Sub ScrollBarNote_Change()
    ' Met à jour l'affichage des éléments en fonction de la position du ScrollBarNote
    
    Note.UpdateElement (ScrollBarNote.value)
End Sub

Private Sub ScrollBarNote_Scroll()
    ' Met à jour l'affichage des éléments en fonction de la position du ScrollBarNote
    
    Note.UpdateElement (ScrollBarNote.value)
End Sub

Private Sub TextBoxEmailOptionFilePath_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    ' Ouvre une boîte de dialogue pour sélectionner un dossier et
    ' met à jour le TextBox avec le chemin sélectionné

    Dim fd As FileDialog
    
    Set fd = Application.FileDialog(msoFileDialogFolderPicker)
    
    If fd.Show = -1 Then
        TextBoxEmailOptionFilePath.text = fd.SelectedItems(1) & IIf(Right(fd.SelectedItems(1), 1) <> "\", "\", "")
    End If
    
    Set fd = Nothing
End Sub

Private Sub TextBoxEmailOptionSendPathFolder_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    ' Ouvre une boîte de dialogue pour sélectionner un dossier et
    ' met à jour le TextBox avec le chemin sélectionné

    Dim fd As FileDialog
    
    Set fd = Application.FileDialog(msoFileDialogFolderPicker)
    
    If fd.Show = -1 Then
        TextBoxEmailOptionSendPathFolder.text = fd.SelectedItems(1) & IIf(Right(fd.SelectedItems(1), 1) <> "\", "\", "")
    End If
    
    Set fd = Nothing
End Sub

Private Sub UserForm_Initialize()
    ' Elle configure les éléments de l'interface utilisateur,
    ' charge les données des feuilles de calcul associées (Etudiants, Enseignants, IntervenantsMissions, GrillePoints),
    ' et crée les contrôles nécessaires (TextBox, CheckBox, ComboBox, etc.) pour chaque section du formulaire
    ' Les informations sont récupérées à partir des feuilles de calcul,
    ' et les éléments sont ajoutés dynamiquement aux différentes zones du formulaire


    Dim WsTeacher As Worksheet
    Dim WsMission As Worksheet
    
    Set ALL_TEXTBOX = New Collection ' Stocke l'instance pour eviter sa destruction
    Set ALL_CHECKBOX = New Collection
    Set ALL_COMMANDBUTTON = New Collection
    
    ' -----------------------------------------------------------------------------------------
    
    MultiPageOnglet.value = 0
    
    ComboBoxEmailType.Clear
    ComboBoxEmailType.AddItem ("Relevé de Notes")
    ComboBoxEmailType.AddItem ("Programme Annuel de l'Etudiant")
    ComboBoxEmailType.AddItem ("Attribution")
    ComboBoxEmailType.ListIndex = 0
    
    ComboBoxEmailOptionType.AddItem ("Version avec mise en forme")
    ComboBoxEmailOptionType.AddItem ("Version texte simple")
    
    ComboBoxEmailOptionFileFormat.AddItem ("PDF")
    ComboBoxEmailOptionFileFormat.AddItem ("XLSX")
    
    ComboBoxEmailOptionFileData.AddItem ("Tout")
    ComboBoxEmailOptionFileData.AddItem ("Essentielles seulement")
    
    ComboBoxEmailOptionSendManageFile.AddItem ("Création automatique")
    ComboBoxEmailOptionSendManageFile.AddItem ("Création manuelle")
    ComboBoxEmailOptionSendManageFile.AddItem ("Sélection par paternes")
    
    Main.LabelEmailOptionSend3.Visible = False
    Main.LabelEmailOptionSend4.Visible = False
    Main.TextBoxEmailOptionSendNameGeneric.Visible = False
    Main.TextBoxEmailOptionSendPathFolder.Visible = False
    
    TextBoxEmailOptionFilePath.text = CreateObject("WScript.Shell").SpecialFolders("Desktop") & "\Projet2025\"
    
    ' -----------------------------------------------------------------------------------------
    
    Set Student = New Student
    Set Student.SetParentFrame = Me.FrameStudentBody
    Set Student.SetTextBox = ALL_TEXTBOX
    Set Student.SetCheckBox = ALL_CHECKBOX
    Set Student.SetWSStudent = ThisWorkbook.Sheets("Etudiants")
    Student.SetNumberElement = Student.GetWSStudent.Cells(Student.GetWSStudent.Rows.count, 1).End(xlUp).row - 1
    
    Me.FrameStudentHeader.Controls("LabelStudentTitle").Caption = CStr(Student.GetNumberElement) & " élèves"
    
    ScrollBarStudent.Min = 1
    ScrollBarStudent.max = Application.WorksheetFunction.max(1, Student.GetNumberElement + 1 - 14) ' Min a 1
    ScrollBarStudent.SmallChange = 1
    
    For i = 1 To Student.GetNumberElement + 1
        Student.AddElement (i)
    Next i
    
    ' -----------------------------------------------------------------------------------------
    
    Set Teacher = New Teacher
    Set Teacher.SetParentFrame = Me.FrameTeacherBody
    Set Teacher.SetTextBox = ALL_TEXTBOX
    Set Teacher.SetCheckBox = ALL_CHECKBOX
    Set Teacher.SetWSTeacher = ThisWorkbook.Sheets("Enseignants")
    Teacher.SetNumberElement = Teacher.GetWSTeacher.Cells(Teacher.GetWSTeacher.Rows.count, 1).End(xlUp).row - 1
    
    Me.FrameTeacherHeader.Controls("LabelTeacherTitle").Caption = CStr(Teacher.GetNumberElement) & " enseignants"
    
    ScrollBarTeacher.Min = 1
    ScrollBarTeacher.max = Application.WorksheetFunction.max(1, Teacher.GetNumberElement + 1 - 14) ' Min a 1
    ScrollBarTeacher.SmallChange = 1
    
    For i = 1 To Teacher.GetNumberElement + 1
        Teacher.AddElement (i)
    Next i
    
    ' -----------------------------------------------------------------------------------------
    
    Set Mission = New Mission
    Set Mission.SetParentFrame = Me.FrameMissionBody
    Set Mission.SetTextBox = ALL_TEXTBOX
    Set Mission.SetCheckBox = ALL_CHECKBOX
    Set Mission.SetWSMission = ThisWorkbook.Sheets("IntervenantsMissions")
    Mission.SetNumberElement = Mission.GetWSMission.Cells(Mission.GetWSMission.Rows.count, 1).End(xlUp).row - 1
    
    Me.FrameMissionHeader.Controls("LabelMissionTitle").Caption = CStr(Mission.GetNumberElement) & " missions"
    
    ScrollBarMission.Min = 1
    ScrollBarMission.max = Application.WorksheetFunction.max(1, Mission.GetNumberElement + 1 - 14) ' Min a 1
    ScrollBarMission.SmallChange = 1
    
    For i = 1 To Mission.GetNumberElement + 1
        Mission.AddElement (i)
    Next i
    
    ' -----------------------------------------------------------------------------------------
    
    Set Note = New Note
    Set Note.SetParentFrame = Me.FrameNoteBody
    Set Note.SetTextBox = ALL_TEXTBOX
    Set Note.SetCheckBox = ALL_CHECKBOX
    Set Note.SetCommandButton = ALL_COMMANDBUTTON
    Set Note.SetWSNote = ThisWorkbook.Sheets("GrillePoints")
    Note.SetNumberElement = Note.GetWSNote.Cells(Note.GetWSNote.Rows.count, 1).End(xlUp).row - 3
    
    Me.FrameNoteHeader.Controls("LabelNoteTitle").Caption = CStr(Note.GetNumberElement) & " notes"
    
    ScrollBarNote.Min = 1
    ScrollBarNote.max = Application.WorksheetFunction.max(1, Note.GetNumberElement + 1 - 14) ' Min a 1
    ScrollBarNote.SmallChange = 1
    
    For i = 1 To Note.GetNumberElement + 1
        Note.AddElement (i)
    Next i
End Sub
