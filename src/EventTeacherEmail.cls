VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "EventTeacherEmail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public WithEvents TextBox As MSForms.TextBox
Attribute TextBox.VB_VarHelpID = -1

' Vérifie si l'email saisi correspond au format valide d'un enseignant (se termine par "@helha.be")
' Si valide, la couleur du texte devient blanche, sinon rouge

Public Sub verifyEmailTeacher()
    If LCase(TextBox.value) Like "*@helha.be" Then
        TextBox.ForeColor = &HFFFFFF
    Else
        TextBox.ForeColor = &H3737B0
    End If
End Sub

Private Sub TextBox_Change()
    verifyEmailTeacher
End Sub


