VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} AdditionalInfo 
   Caption         =   "Informations complémentaires"
   ClientHeight    =   7356
   ClientLeft      =   108
   ClientTop       =   456
   ClientWidth     =   11184
   OleObjectBlob   =   "AdditionalInfo.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "AdditionalInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' Interface pour les informations complémentaires avec des interactions sur certaines zones de texte

Private Sub Label2_Click()
    On Error Resume Next
        Set OutlookApp = CreateObject("Outlook.Application")
    On Error GoTo 0

    If OutlookApp Is Nothing Then
        Exit Sub
    End If

    Set OutlookMail = OutlookApp.CreateItem(0)
    
    With OutlookMail
        .To = "la248648@student.helha.be"
        .Subject = "Demande de contact"
        .Body = "Bonjour," & vbCrLf & vbCrLf & "Je vous contacte concernant..."
        .Display
    End With

    Set OutlookMail = Nothing
    Set OutlookApp = Nothing
End Sub

Private Sub Label20_Click()
    ThisWorkbook.FollowHyperlink ("https://github.com/xen0r-star/AxenFlow")
End Sub

Private Sub Label21_Click()
    ThisWorkbook.FollowHyperlink ("https://github.com/xen0r-star/AxenFlow/blob/b51affff09b7f868f56213eb52e5a8b90d3270b5/LICENSE")
End Sub

Private Sub Label5_Click()
    ThisWorkbook.FollowHyperlink ("https://axenflow.web.app/")
End Sub

Private Sub Label6_Click()
    ThisWorkbook.FollowHyperlink ("https://github.com/xen0r-star")
End Sub
