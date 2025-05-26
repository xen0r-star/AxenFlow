VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "EventStudentEmail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public WithEvents TextBox As MSForms.TextBox
Attribute TextBox.VB_VarHelpID = -1

' Vérifie si l'email saisi correspond au format valide d'un étudiant
' (25 caractères, terminaison "@student.helha.be" et commence par "la")
' Si valide, la couleur du texte devient blanche, sinon rouge


Public Sub verifyEmailStudent()
    If LCase(TextBox.value) Like "*@student.helha.be" And Len(TextBox.value) = 25 And Left(TextBox.value, 2) = "la" Then
        TextBox.ForeColor = &HFFFFFF
    Else
        TextBox.ForeColor = &H3737B0
    End If
End Sub

Private Sub TextBox_Change()
    verifyEmailStudent
End Sub



