VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "EventMatri"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public WithEvents TextBox As MSForms.TextBox
Attribute TextBox.VB_VarHelpID = -1

' Vérifie si la valeur du TextBox est un matricule valide (8 caractères, commençant par "LA")
' Si valide, la couleur du texte devient blanche, sinon rouge

Public Sub verifyMatricule()
    If Len(TextBox.value) = 8 And Left(TextBox.value, 2) = "LA" Then
        TextBox.ForeColor = &HFFFFFF
    Else
        TextBox.ForeColor = &H3737B0
    End If
End Sub

Private Sub TextBox_Change()
    verifyMatricule
End Sub




