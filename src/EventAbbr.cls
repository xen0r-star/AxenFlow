VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "EventAbbr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public WithEvents TextBox As MSForms.TextBox
Attribute TextBox.VB_VarHelpID = -1

' Vérifie si la valeur saisie correspond à l'abréviation des colonnes 2 et 3 de la feuille "Enseignants"
' Si l'abréviation est correcte et de longueur 5, le texte devient blanc, sinon rouge

Public Sub verifyAbbr()
    Dim ws As Worksheet
    Dim firstAbbr As String
    Dim secondAbbr As String

    Set ws = ThisWorkbook.Sheets("Enseignants")

    Dim rowIndex As Integer
    rowIndex = CInt(Split(TextBox.name, "_")(1)) + 1

    firstAbbr = Left(NormalizeString(ws.Cells(rowIndex, 2).value), 3)
    secondAbbr = Left(NormalizeString(ws.Cells(rowIndex, 3).value), 2)
    
    If UCase(firstAbbr & secondAbbr) = TextBox.value And Len(TextBox.value) = 5 Then
        TextBox.ForeColor = &HFFFFFF
    Else
        TextBox.ForeColor = &H3737B0
    End If
End Sub


Private Sub TextBox_Change()
    verifyAbbr
End Sub

