Configuration Homework
{ 
   Import-DscResource -ModuleName ComputerManagementDsc 
   Import-DscResource -ModuleName PsDesiredStateConfiguration
   
   Node localhost 
   { 
      File Share
      {
         Ensure = "Present"
         Type = "Directory"
         DestinationPath = "C:\DSC"
      } 
      
      SmbShare NewShare
      { 
         Ensure = "Present"
         Name = "Exam"
         Path = "C:\DSC"
         FullAccess = 'WSAA\Domain Admin'
         ReadAccess = @("WSAA\N1$", "WSAA\N2$")	
    FolderEnumerationMode = ‘AccessBased’
    Ensure = ‘Present’
    Dependson = ‘[File]SharedFolder’
      } 
      
      File IndexPage1
      {
Ensure = ‘Present’
Contents = ‘Running on N1’
Type = ‘File’
DestinationPath = ‘C:\Share\IndexN1.html’
Dependson = ‘[File]SharedFolder’
      }
File IndexPage2
{
Ensure = ‘Present’
Contents = ‘Running on N2’
Type = ‘File’
DestinationPath = ‘C:\Share\IndexN2.html’
Dependson = ‘[File]SharedFolder’
}
   }

   ForEach($Node in $AllNodes)
   {
      Node $Node.NodeName
      {
         ForEach($Feature in $Node.WindowsFeatures)
         {
            WindowsFeature $Feature
            {
               Ensure = "Present"
               Name = $Feature
            }
         }

         File IndexPage
         {
            Ensure = "Present"
            Type = "File"
            Contents = "Running on " + $Node.NodeName
            SourcePath = "\\DC\DSC\index.html"
            DestinationPath = "C:\inetpub\wwwroot"
         }
      }
   }
}