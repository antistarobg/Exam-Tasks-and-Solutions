Configuration Share
{
	Import-DscResource –ModuleName PsDesiredStateConfiguration
	Import-DscResource –ModuleName ComputerManagementDSC
    ForEach($Node in $AllNodes)
    {
        Node $Node.NodeName
        {
            ForEach($Feature in $Node.WindowsFeatures)
            {

Node localhost
{	
File SharedFolder
{	
        Ensure = ‘Present’
        Type = ‘Directory’
        DestinationPath = ‘C:\Share’
}
SMBShare CreateShare
{
    Name = ‘Share’
    Path  = ‘C:\Share’
    FullAccess = ‘WSAA\Domain Admins’
    ReadAccess = @(“WSAA\S1$”, “WSAA\S2$”)
    FolderEnumerationMode = ‘AccessBased’
    Ensure = ‘Present’
    Dependson = ‘[File]SharedFolder’
}
File IndexPage1
{
Ensure = ‘Present’
Contents = ‘Running on SRV1’
Type = ‘File’
DestinationPath = ‘C:\Share\IndexN1.html’
Dependson = ‘[File]SharedFolder’
}
File IndexPage2
{
Ensure = ‘Present’
Contents = ‘Running on SRV2’
Type = ‘File’
DestinationPath = ‘C:\Share\IndexN2.html’
Dependson = ‘[File]SharedFolder’
}
Node N1
{
WindowsFeature IIS
{
Name = ‘Web-Server’
Ensure = ‘Present’
}
            File IndexPage
            {
                Ensure = "Present"
                Contents = "Running on " + $Node.NodeName
                Type = "File"
                DestinationPath = "C:\inetpub\wwwroot\index.html"
}

Node N2
{
WindowsFeature IIS
{
Name = ‘Web-Server’
Ensure = ‘Present’
}
            File IndexPage
            {
                Ensure = "Present"
                Contents = "Running on " + $Node.NodeName
                Type = "File"
                DestinationPath = "C:\inetpub\wwwroot\index.html"

}

}
}
}
}

}
}
}