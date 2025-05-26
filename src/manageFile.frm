VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ManageFile 
   Caption         =   "Fichier"
   ClientHeight    =   3996
   ClientLeft      =   36
   ClientTop       =   192
   ClientWidth     =   7584
   OleObjectBlob   =   "manageFile.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "manageFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Id As String
Private name As String
Private firstName As String
Private Email As String
Private Path As String

' Interface pour gérer manuellement l'emplacement du fichier
' ou le générer automatiquement avent de l'ajouter en pièce jointe de l'e-mail

Private Sub ButtonAuto_Click()
    TextBoxFilePath.text = "Création automatique du fichier"
End Sub

Private Sub ButtonValidate_Click()
    If TextBoxFilePath.text = "Création automatique du fichier" Then
        Path = ""
    End If
    
    Unload Me
End Sub

Private Sub UserForm_Activate()
    Text1.Caption = Id & " - " & name & " " & firstName
    Text2.Caption = Email
    Me.Caption = "Fichier - " & name & " " & firstName
End Sub

Private Sub TextBoxFilePath_MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    Dim fd As Office.FileDialog
    
    Set fd = Application.FileDialog(msoFileDialogFilePicker)
    
    With fd
        .AllowMultiSelect = False
        .Title = "Sélectionner un fichier"
        .Filters.Clear
        
        .Filters.Add "Fichiers PDF", "*.pdf"
        .Filters.Add "Fichiers Word", "*.docx; *.docm; *.dotx; *.dotm"
        .Filters.Add "Fichiers Excel", "*.xlsx; *.xlsm; *.xlsb; *.xltx; *.xltm"
        .Filters.Add "Fichiers PowerPoint", "*.pptx; *.pptm; *.ppsx; *.ppsm"
        .Filters.Add "Fichiers Texte", "*.txt; *.csv"
        .Filters.Add "Fichiers Image", "*.jpg; *.jpeg; *.png; *.gif; *.bmp; *.tiff"
        .Filters.Add "Tous les fichiers", "*.*"
        
        .FilterIndex = 1
    
        If .Show = True Then
            TextBoxFilePath.text = .SelectedItems(1)
        End If
    End With
    
    Set fd = Nothing
End Sub

Public Property Let SetId(ByVal value As String)
    Id = value
End Property

Public Property Let SetName(ByVal value As String)
    name = value
End Property

Public Property Let SetFirstName(ByVal value As String)
    firstName = value
End Property

Public Property Let SetEmail(ByVal value As String)
    Email = value
End Property

Public Property Get GetPath() As String
    GetPath = Path
End Property
