#############################################################################################################################
#Summary:		This tool is designed for generating Database reports related to FARM, Web Application and Database
#				Report is having 3 categorie - FARM, Web application, Database 
#				At the end of the excution HTML report will genrate
#############################################################################################################################
# Remove PS Snapin
	Remove-PSSnapin "Microsoft.SharePoint.Powershell" -erroraction silentlycontinue 
# Add PS Snapin	
	Write-Host "Adding PS Snapin...."
	Add-PSSnapin "Microsoft.SharePoint.Powershell" -erroraction silentlycontinue 
#############################################################################################################################
# Adding Assembly
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")	
#############################################################################################################################
# Script
# Trap
  trap [Exception] 
	{
		Write-Host $("Exception: " + $_.Exception.Message) -ForegroundColor Red	
        continue
    }
# Getting Environment Details
		$userdomain = [Environment]::UserDomainName
		$user = [Environment]::UserName
		$machine = [Environment]::MachineName		
		$date = (Get-Date -Format MM_dd_yyyy)
		$dir = Get-Location
	# Creating DBAudit Form
		$DBAuditForm = New-Object System.Windows.Forms.Form
		$DBAuditForm.width =649
		$DBAuditForm.height =211
		$DBAuditForm.Text = "SP_AdminUtility_DatabaseAudit_v0.2"
		$DBAuditForm.MinimizeBox = $False
		$DBAuditForm.MaximizeBox = $False
		$DBAuditForm.BackColor = "GradientInactiveCaption"
		$DBAuditForm.ShowIcon = $false
		$DBAuditForm.Font = "Candara, 9 pt"
		$DBAuditForm.Opacity =80
		$DBAuditForm.FormBorderStyle = "SizableToolWindow"
		$DBAuditForm.WindowState = "Normal"		
	#Windows Form Position
		$DBAuditForm.StartPosition = "WindowsDefaultLocation"
	#Disabling cancle button functionality
		$DBAuditForm.Add_FormClosing( { $_.Cancel = $true} ) 
	# Set form on top
		$DBAuditForm.Topmost = $True
	#Progress Label -WebApplication
		$WebPro= New-Object System.Windows.Forms.Label
		$WebPro.Location = New-Object System.Drawing.Size(11, 101)
		$WebPro.size = New-Object System.Drawing.Size(560,15)
		$WebPro.Visible = $false
		$DBAuditForm.Controls.Add($WebPro)	
	#Progress Label -Database
		$DBPro= New-Object System.Windows.Forms.Label
		$DBPro.Location = New-Object System.Drawing.Size(11, 125)
		$DBPro.size = New-Object System.Drawing.Size(560,15)
		$DBPro.Visible = $false
		$DBAuditForm.Controls.Add($DBPro)		
	#Progress Label - Site Collection
		$SCPro= New-Object System.Windows.Forms.Label
		$SCPro.Location = New-Object System.Drawing.Size(11, 148)
		$SCPro.size = New-Object System.Drawing.Size(565,40)
		$SCPro.Visible = $false
		$DBAuditForm.Controls.Add($SCPro)			
	# Adding User Choice
		$DBAudit =New-Object System.Windows.Forms.ComboBox
		$DBAudit.Location =New-Object System.Drawing.Size(88, 19)
		$DBAudit.Size =New-Object System.Drawing.Size(158, 21)
		$add= $DBAudit.Items.Add("FARM Level")
		$add= $DBAudit.Items.Add("WebApplication Level") 
		$add=  $DBAudit.Items.Add("Database Level")	
		$DBAudit.SelectedIndex = 0;	
		$DBAuditForm.Controls.Add($DBAudit)	
	# Adding  Label
		$DBAuditLevel = New-Object System.Windows.Forms.Label
		$DBAuditLevel.Location = New-Object System.Drawing.Size(13,19)
		$DBAuditLevel.Size = New-Object System.Drawing.Size(58, 13)
		$DBAuditLevel.Text = "Audit"
		$DBAuditForm.Controls.Add($DBAuditLevel)		
		$FARMAuditButton = New-Object System.Windows.Forms.Button
		$FARMAuditButton.Location = New-Object System.Drawing.Size(88, 46)
		$FARMAuditButton.Size =  New-Object System.Drawing.Size(75, 21)
		$FARMAuditButton.Text = "OK"
	#Button Click event for audit level choice	
		$FARMAuditButton.Add_Click({		
			$choice = $DBAudit.SelectedItem.ToString()
			switch($choice)
			{
				# If choice is FARM level
				("FARM Level")
				{	
					#  Creating File
					New-Item -ItemType File -Name  DBAudit.html -Force
					# Adding HTML Tags and Information  in File
					Add-Content  DBAudit.html "<html xmlns=""http://www.w3.org/1999/xhtml"" >"
					Add-Content  DBAudit.html  "<head>"
					Add-Content  DBAudit.html  "<title>DB Audit Report - Farm Level</title>"
					Add-Content  DBAudit.html  "</head>"
					Add-Content  DBAudit.html  "<body>"				
					# Creating HTML table
					Add-Content  DBAudit.html  "<table border=1 bordercolor=#FFCC00 style= font-family:Candara,arial,sans-serif;font-size:13px width=80% cellpadding=3 cellspacing=3>"											
					# collecting WebApplications
					[array] $webapp = Get-SPWebApplication  -ErrorAction Stop
					Write-Host "WebApplication" $webapp.Count		
					# Int for total counts 
					[int] $webcount = 0
					[int] $dbcount = 0
					[int] $sccount = 0
					[float] $totaldbsize = 0
					Add-Content  DBAudit.html  "<tr>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html  "Audit Type"
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html    "FARM Level"
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "</tr>"
					Add-Content  DBAudit.html  "<tr>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html  "User"
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html    $userdomain"\"$user # User Name
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "</tr>"
					Add-Content  DBAudit.html  "<tr>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html  "Machine Name"
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html    $machine # Machine Name
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "</tr>"
					Add-Content  DBAudit.html  "<tr>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html  "Date"
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html    $date # Current Date
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "</tr>"
					# Processing for WebApplication
					foreach($app in $webapp)
					{
						$WebPro.Visible = $true
						$WebPro.Text = "Processing for "+$app.Url											
						$WebPro.Refresh()										
						Write-Host $app.Url
						# Collectiing Contetn Databases for Web Application
						[array] $contentdb = Get-SPContentDatabase -WebApplication $app.Url -ErrorAction SilentlyContinue
						Write-Host "Content Database"$contentdb.Count			
						# if Database count is -gt 0
						if($contentdb.Count -gt 0)
						{													
							Add-Content  DBAudit.html  "<tr>"
							Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"
							Add-Content   DBAudit.html  "WebApplication Name"
							Add-Content  DBAudit.html  "</td>"
							Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"
							Add-Content   DBAudit.html  "<B><I>"
							Add-Content   DBAudit.html  $app.Url # Web Application URL
							Add-Content   DBAudit.html "</B></I>"
							Add-Content  DBAudit.html  "</td>"
							Add-Content  DBAudit.html  "</tr>"			
							# Processing for content database												
							foreach($db in $contentdb)
							{
								Write-Host $db
								$DBPro.Visible = $true
								$DBPro.Text = "Processing for $db"
								$DBPro.Refresh()												
								# collecting Sitec collection within DB
								$dbf = Get-SPSite -ContentDatabase $db -Limit All 	-ErrorAction SilentlyContinue
								# Getting Database size in GB (Total Disk space required for backup)
								[float] $dbSize = $db.disksizerequired/1GB													
								$dbSize = [System.Math]::Round($dbsize, 2) 	
								# float variable to calculate totol site collection size within DB		
								$totaldbsize = $totaldbsize + $dbSize
								[float] $totalmb = 0
								Add-Content  DBAudit.html  "<tr>"
								Add-Content  DBAudit.html  "<td  bgcolor=#FFCC99>"
								Add-Content  DBAudit.html  "Database Name \ Server \ Farm \ Id \ IsReadOnly  "
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "<td bgcolor=#FFCC99 aligned =justify >"		
								Add-Content  DBAudit.html  "<B><I>"
								Add-Content  DBAudit.html  $db.Name	 # Database Name
								Add-Content  DBAudit.html "</B></I>"													
								Add-Content  DBAudit.html	"\ "			
								Add-Content  DBAudit.html	$db.Server		# Database Server Name					 
								Add-Content  DBAudit.html	"\ "
								Add-Content  DBAudit.html	 $db.FARM	# Associated with FARM
								Add-Content  DBAudit.html	"\ "
								Add-Content  DBAudit.html	 $db.ID	 # DB GUID
								Add-Content  DBAudit.html	"\ "
								Add-Content  DBAudit.html	 $db.IsReadOnly		# Database IsReadOnly - True/False																						
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "</tr>"		
								Add-Content  DBAudit.html  "<tr>"
								Add-Content  DBAudit.html  "<td >"
								Add-Content  DBAudit.html  "Size of the Database (Total Disk Space)"
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "<td  >"	
								Add-Content  DBAudit.html $dbSize # Database Size
								Add-Content  DBAudit.html  "GB"
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "</tr>"
								Add-Content  DBAudit.html  "<tr>"
								Add-Content  DBAudit.html  "<td >"
								Add-Content  DBAudit.html  "Total number of site collections"
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "<td >"	
								Add-Content  DBAudit.html  $db.currentsitecount # Total number of DB
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "</tr>"		
								Write-Host "Site Collection "$dbf.Count # Display on console
								Add-Content  DBAudit.html  "<tr>"
								Add-Content  DBAudit.html  "<td>"
								Add-Content  DBAudit.html  "Site Collection URL"															
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "<td>"
								Add-Content  DBAudit.html  "Size  -SCA - Last ModifiedDate"															
								Add-Content  DBAudit.html  "</td>"	
								Add-Content  DBAudit.html  "</tr>"
								# Processing for Site collection,  If number of site collection is -gt 0
								if($dbf.Count -gt 0)
								{
									# Processing for each site collection
									foreach($sc in $dbf)										
									{												
										$SCPro.Visible = $true
										$SCPro.Text = "Processing for $sc"
										$SCPro.Refresh()
										Write-Host $sc
										Add-Content  DBAudit.html  "<tr>"
										Add-Content  DBAudit.html  "<td>"
										Add-Content  DBAudit.html  $sc.url		
										Add-Content  DBAudit.html  "</td>"							
										Add-Content  DBAudit.html  "<td>"
										# if Site collectionusage space is -gt or -eq 1024 convrt it into GB
										if((($sc.usage.storage/1MB) -gt 1024) -or (($sc.usage.storage/1MB) -eq 1024))
										{
											[float] $scsize  =$sc.usage.storage/1GB
											$scsize = [System.Math]::Round($scsize, 2) 
											Add-Content  DBAudit.html	$scsize" GB"
										}
										else
										{
											[float] $scsize = $sc.usage.storage/1MB
											$scsize = [System.Math]::Round($scsize, 2) 
											Add-Content  DBAudit.html	$scsize" MB"
										}		
										Add-Content  DBAudit.html  "-"
										Add-Content  DBAudit.html  $sc.Owner
										Add-Content  DBAudit.html  "-"														
										Add-Content  DBAudit.html  $sc.LastContentModifiedDate 
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "</tr>"
										# Adding total site collection (within DB) size
										$totalmb = $totalmb +($sc.usage.storage/1MB)
										# Incrementing Processed site collection count 
										$sccount ++
									}	
								}
								# If site collection -eq 0
								else
								{
										Add-Content  DBAudit.html  "<tr>"
										Add-Content  DBAudit.html  "<td>"
										Add-Content  DBAudit.html  "No site collection found"	
										Add-Content  DBAudit.html  "</td>"							
										Add-Content  DBAudit.html  "<td>"			
										Add-Content  DBAudit.html "-"
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "</tr>"
								}
								# Incrementing Processed site collection count  within DB
								$sccount =+ $sccount
								# Converting Total size of Site collections with DB
								$totalmb  =$totalmb/1024
								$totalmb = [System.Math]::Round($totalmb, 2)
								Add-Content  DBAudit.html  "<tr>"
								Add-Content  DBAudit.html  "<td>"
								Add-Content  DBAudit.html  "Site Collection (Total size)"
								Add-Content  DBAudit.html  "</td>"							
								Add-Content  DBAudit.html  "<td>"
								Add-Content  DBAudit.html $totalmb" GB"
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "</tr>"
								# Incrementing Processed  DB count 
								$dbcount++
							}	
							$totaldbsize =+$totaldbsize
						}
						# If Database is -eq 0
						else
						{
							Add-Content  DBAudit.html  "<tr>"
							Add-Content  DBAudit.html  "<td width = 30% bgcolor =#FFCC66>"
							Add-Content  DBAudit.html  "WebApplication Name"
							Add-Content  DBAudit.html  "</td>"
							Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"
							Add-Content  DBAudit.html  "<B><I>"
							Add-Content  DBAudit.html  $app.url
							Add-Content  DBAudit.html "</B></I>"
							Add-Content  DBAudit.html  "</td>"
							Add-Content  DBAudit.html  "</tr>"
							Add-Content  DBAudit.html  "<tr>"
							Add-Content  DBAudit.html  "<td width = 30% bgcolor=#FFCC99>"
							Add-Content  DBAudit.html  "Database Name"
							Add-Content  DBAudit.html  "</td>"
							Add-Content  DBAudit.html  "<td bgcolor=#FFCC99 aligned =justify >"		
							Add-Content  DBAudit.html  "<B><I>"
							Add-Content  DBAudit.html  "No Database found"
							Add-Content  DBAudit.html "</B></I>"
							Add-Content  DBAudit.html  "</td>"
							Add-Content  DBAudit.html  "</tr>"	
						}	
						# Incrementing Processed  Site collection count within Web Application
						$sccount =+ $sccount
						# Incrementing Processed  DB count within Web Application
						$dbcount =+ $dbcount
						# Incrementing Processed   Web Application
						$webcount++
					}					
					# Summary
					Add-Content  DBAudit.html  "<tr>"
					Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"	
					Add-Content  DBAudit.html  "Total Database Size (Disk Space required)"
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"	
					Add-Content  DBAudit.html 	$totaldbsize" GB" # Total Disk Space requirment
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "</tr>"		
					Add-Content  DBAudit.html  "<tr>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html  "Total WebApplication Processed"
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html    $webcount # Number of Web Application
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "</tr>"
					Add-Content  DBAudit.html  "<tr>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html  "Total Database Processed"
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html    $dbcount # total number of database
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "</tr>"
					Add-Content  DBAudit.html  "<tr>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html  "Total SiteCollection Processed"
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "<td>"
					Add-Content  DBAudit.html   $sccount # total number of site collection
					Add-Content  DBAudit.html  "</td>"
					Add-Content  DBAudit.html  "</tr>"
					Add-Content  DBAudit.html  "</table>"
					Add-Content  DBAudit.html "</body>"						
					Add-Content  DBAudit.html "<html>"												
					$WebPro.Text = "Total WebApplication Processed: $webcount "
					$WebPro.Refresh()
					$DBPro.Text = "Total Database Processed: $dbcount "
					$DBPro.Refresh()
					$SCPro.Text = "Total SiteCollection Processed:	$sccount "
					$SCPro.Refresh()
					[System.Windows.Forms.MessageBox]::Show("Operation Completed", "Message") 					
					#$DBAuditForm.Close()
					#$DBAuditForm.Dispose()		
					Invoke-Item  DBAudit.html	
					$WebPro.Text = ""
					$WebPro.Refresh()
					$DBPro.Text = ""
					$DBPro.Refresh()
					$SCPro.Text = ""
					$SCPro.Refresh()
					Write-Host "Operation Completed"
					break
				}
				# Audit for Web Application/s User can select one or more web applications
				("WebApplication Level")
				{
					$WebPro.Visible = $true
					$WebPro.Text = " "
					$WebPro.Refresh()
					$DBPro.Visible = $true
					$DBPro.Text = " "
					$DBPro.Refresh()								
					$SCPro.Visible = $true
					$SCPro.Text = " "
					$SCPro.Refresh()									
					$FARMAuditButton.Visible = $false
					# Creating Web Audit Button
					$WebAuditButton = New-Object System.Windows.Forms.Button
					$WebAuditButton.Location = New-Object System.Drawing.Size(88, 46)
					$WebAuditButton.Size =  New-Object System.Drawing.Size(75, 21)
					$WebAuditButton.Text = "Start"
					$DBAuditForm.Controls.Add($WebAuditButton)	
					$WebAppList = New-Object System.Windows.Forms.ListBox
					$WebAppList.Location = New-Object System.Drawing.Size(329, 22)
					$WebAppList.Size = New-Object System.Drawing.Size(278, 69)
					$weblist = Get-SPWebApplication -ErrorAction Stop
					# Collecting Web Applications
					foreach($web in $weblist)
					{
						$WebAppList.Items.Add($web.Url)
					}
					# Allowing Multiple Selection
					$WebAppList.SelectionMode = "MultiExtended"
					$DBAuditForm.Controls.Add($WebAppList)
					$WebAuditLevel = New-Object System.Windows.Forms.Label
					$WebAuditLevel.Location = New-Object System.Drawing.Size(264, 19)
					$WebAuditLevel.Size = New-Object System.Drawing.Size(58, 13)
					$WebAuditLevel.Text = "Web App"
					$DBAuditForm.Controls.Add($WebAuditLevel)	
					# Execution
					$WebAuditButton.Add_Click({
									# collecting WebApplications
									[array] $webapp = $WebAppList.SelectedItems
									Write-Host "WebApplication" $webapp.Count
									if( $webapp.Count -gt 0 )
									{
										# Creating File
										New-Item -ItemType File -Name  DBAudit.html -Force
										# Adding HTML Tags and Information  in File
										Add-Content  DBAudit.html "<html xmlns=""http://www.w3.org/1999/xhtml"" >"
										Add-Content  DBAudit.html  "<head>"
										Add-Content  DBAudit.html  "<title>DB Audit Report - WebApplication Level</title>"
										Add-Content  DBAudit.html  "</head>"
										Add-Content  DBAudit.html  "<body>"				
										# Creating HTML table
										Add-Content  DBAudit.html  "<table border=1 bordercolor=#FFCC00 style= font-family:Candara,arial,sans-serif;font-size:13px width=80% cellpadding=3 cellspacing=3>"											
										# Int for total counts 
										[int] $webcount = 0
										[int] $dbcount = 0
										[int] $sccount = 0
										[float] $totaldbsize = 0
										Add-Content  DBAudit.html  "<tr>"
										Add-Content  DBAudit.html  "<td>"
										Add-Content  DBAudit.html  "Audit Type"
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "<td>"
										Add-Content  DBAudit.html    "WebApplication Level"
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "</tr>"
										Add-Content  DBAudit.html  "<tr>"
										Add-Content  DBAudit.html  "<td>"
										Add-Content  DBAudit.html  "User"
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "<td>"
										Add-Content  DBAudit.html    $userdomain"\"$user # User Name
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "</tr>"
										Add-Content  DBAudit.html  "<tr>"
										Add-Content  DBAudit.html  "<td>"
										Add-Content  DBAudit.html  "Machine Name"
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "<td>"
										Add-Content  DBAudit.html    $machine # Machine Name
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "</tr>"
										Add-Content  DBAudit.html  "<tr>"
										Add-Content  DBAudit.html  "<td>"
										Add-Content  DBAudit.html  "Date"	
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "<td>"
										Add-Content  DBAudit.html    $date # Current Date
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "</tr>"
										# Processing for WebApplication
									foreach($app in $webapp)
									{
										$WebPro.Visible = $true
										$WebPro.Text = "Processing for "+$app
										$WebPro.Refresh()			
										Write-Host $app.Url
										# Collectiing Contetn Databases for Web Application
										[array] $contentdb = Get-SPContentDatabase -WebApplication $app -ErrorAction SilentlyContinue
										Write-Host "Content Database"$contentdb.Count			
										# if Database count is -gt 0
										if($contentdb.Count -gt 0)
										{													
											Add-Content  DBAudit.html  "<tr>"
											Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"
											Add-Content   DBAudit.html  "WebApplication Name"
											Add-Content  DBAudit.html  "</td>"
											Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"
											Add-Content   DBAudit.html  "<B><I>"
											Add-Content   DBAudit.html  $app  # Web Application URL
											Add-Content   DBAudit.html "</B></I>"
											Add-Content  DBAudit.html  "</td>"
											Add-Content  DBAudit.html  "</tr>"			
											# Processing for content database																											
											foreach($db in $contentdb)
											{
												Write-Host $db
												$DBPro.Visible = $true
												$DBPro.Text = "Processing for $db"
												$DBPro.Refresh()												
												# collecting Sitec collection within DB
												$dbf = Get-SPSite -ContentDatabase $db -Limit All 	-ErrorAction SilentlyContinue
												# Getting Database size in GB (Total Disk space required for backup)
												[float] $dbSize = $db.disksizerequired/1GB													
												$dbSize = [System.Math]::Round($dbsize, 2) 	
												# float variable to calculate totol site collection size within DB		
												$totaldbsize = $totaldbsize + $dbSize
												[float] $totalmb = 0
												Add-Content  DBAudit.html  "<tr>"
												Add-Content  DBAudit.html  "<td  bgcolor=#FFCC99>"
												Add-Content  DBAudit.html  "Database Name \ Server \ Farm \ Id \ IsReadOnly  "
												Add-Content  DBAudit.html  "</td>"
												Add-Content  DBAudit.html  "<td bgcolor=#FFCC99 aligned =justify >"		
												Add-Content  DBAudit.html  "<B><I>"
												Add-Content  DBAudit.html  $db.Name	 # Database Name
												Add-Content  DBAudit.html "</B></I>"													
												Add-Content  DBAudit.html	"\ "			
												Add-Content  DBAudit.html	$db.Server		# Database Server Name					 
												Add-Content  DBAudit.html	"\ "
												Add-Content  DBAudit.html	 $db.FARM	# Associated with FARM
												Add-Content  DBAudit.html	"\ "
												Add-Content  DBAudit.html	 $db.ID	 # DB GUID
												Add-Content  DBAudit.html	"\ "
												Add-Content  DBAudit.html	 $db.IsReadOnly		# Database IsReadOnly - True/False																						
												Add-Content  DBAudit.html  "</td>"
												Add-Content  DBAudit.html  "</tr>"		
												Add-Content  DBAudit.html  "<tr>"
												Add-Content  DBAudit.html  "<td >"
												Add-Content  DBAudit.html  "Size of the Database (Total Disk Space)"
												Add-Content  DBAudit.html  "</td>"
												Add-Content  DBAudit.html  "<td  >"	
												Add-Content  DBAudit.html $dbSize # Database Size
												Add-Content  DBAudit.html  "GB"
												Add-Content  DBAudit.html  "</td>"
												Add-Content  DBAudit.html  "</tr>"
												Add-Content  DBAudit.html  "<tr>"
												Add-Content  DBAudit.html  "<td >"
												Add-Content  DBAudit.html  "Total number of site collections"
												Add-Content  DBAudit.html  "</td>"
												Add-Content  DBAudit.html  "<td >"	
												Add-Content  DBAudit.html  $db.currentsitecount # Total number of DB
												Add-Content  DBAudit.html  "</td>"
												Add-Content  DBAudit.html  "</tr>"		
												Write-Host "Site Collection "$dbf.Count #
												Add-Content  DBAudit.html  "<tr>"
												Add-Content  DBAudit.html  "<td>"
												Add-Content  DBAudit.html  "Site Collection URL"															
												Add-Content  DBAudit.html  "</td>"
												Add-Content  DBAudit.html  "<td>"
												Add-Content  DBAudit.html  "Size  -SCA - Last ModifiedDate"															
												Add-Content  DBAudit.html  "</td>"	
												Add-Content  DBAudit.html  "</tr>"
												# Processing for Site collection
												if($dbf.Count -gt 0)
												{
													foreach($sc in $dbf)										
													{												
														$SCPro.Visible = $true
														$SCPro.Text = "Processing for $sc"
														$SCPro.Refresh()
														Write-Host $sc
														Add-Content  DBAudit.html  "<tr>"
														Add-Content  DBAudit.html  "<td>"
														Add-Content  DBAudit.html  $sc.url		
														Add-Content  DBAudit.html  "</td>"							
														Add-Content  DBAudit.html  "<td>"
														# if Site collectionusage space is -gt or -eq 1024 convrt it into GB
														if((($sc.usage.storage/1MB) -gt 1024) -or (($sc.usage.storage/1MB) -eq 1024))
														{
															[float] $scsize  =$sc.usage.storage/1GB
															$scsize = [System.Math]::Round($scsize, 2) 
															Add-Content  DBAudit.html	$scsize" GB"
														}
														else
														{
															[float] $scsize = $sc.usage.storage/1MB
															$scsize = [System.Math]::Round($scsize, 2) 
															Add-Content  DBAudit.html	$scsize" MB"
														}		
														Add-Content  DBAudit.html  "-"
														Add-Content  DBAudit.html  $sc.Owner
														Add-Content  DBAudit.html  "-"														
														Add-Content  DBAudit.html  $sc.LastContentModifiedDate 
														Add-Content  DBAudit.html  "</td>"
														Add-Content  DBAudit.html  "</tr>"
														# Adding total site collection (within DB) size
														$totalmb = $totalmb +($sc.usage.storage/1MB)
														# Incrementing Processed site collection count 
														$sccount ++
													}	
												}
												# if Site collection count -eq 0
												else
												{
														Add-Content  DBAudit.html  "<tr>"
														Add-Content  DBAudit.html  "<td>"
														Add-Content  DBAudit.html  "No site collection found"	
														Add-Content  DBAudit.html  "</td>"							
														Add-Content  DBAudit.html  "<td>"			
														Add-Content  DBAudit.html "-"
														Add-Content  DBAudit.html  "</td>"
														Add-Content  DBAudit.html  "</tr>"
												}
												# Incrementing Processed site collection count  within DB
											$sccount =+ $sccount
											# Converting Total size of Site collections with DB
											$totalmb  =$totalmb/1024
											$totalmb = [System.Math]::Round($totalmb, 2)
											Add-Content  DBAudit.html  "<tr>"
											Add-Content  DBAudit.html  "<td>"
											Add-Content  DBAudit.html  "Site Collection (Total size)"
											Add-Content  DBAudit.html  "</td>"							
											Add-Content  DBAudit.html  "<td>"
											Add-Content  DBAudit.html $totalmb" GB"
											Add-Content  DBAudit.html  "</td>"
											Add-Content  DBAudit.html  "</tr>"
											# Incrementing Processed  DB count 
											$dbcount++
										}	
										# Incrementing Database size count
										$totaldbsize =+$totaldbsize
									}
									# If Database count -eq 0
									else
									{
										Add-Content  DBAudit.html  "<tr>"
										Add-Content  DBAudit.html  "<td width = 30% bgcolor =#FFCC66>"
										Add-Content  DBAudit.html  "WebApplication Name"
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"
										Add-Content  DBAudit.html  "<B><I>"
										Add-Content  DBAudit.html  $app # Application name
										Add-Content  DBAudit.html "</B></I>"
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "</tr>"
										Add-Content  DBAudit.html  "<tr>"
										Add-Content  DBAudit.html  "<td width = 30% bgcolor=#FFCC99>"
										Add-Content  DBAudit.html  "Database Name"
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "<td bgcolor=#FFCC99 aligned =justify >"		
										Add-Content  DBAudit.html  "<B><I>"
										Add-Content  DBAudit.html  "No Database found" # Information
										Add-Content  DBAudit.html "</B></I>"
										Add-Content  DBAudit.html  "</td>"
										Add-Content  DBAudit.html  "</tr>"	
									}	
									# Incrementing Processed  Site collection count within Web Application
									$sccount =+ $sccount
									# Incrementing Processed  DB count within Web Application
									$dbcount =+ $dbcount
									# Incrementing Processed   Web Application
									$webcount++
								}			
								# Summary
								Add-Content  DBAudit.html  "<tr>"
								Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"	
								Add-Content  DBAudit.html  "Total Database Size (Disk Space required)"
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"	
								Add-Content  DBAudit.html 	$totaldbsize" GB" # Database Size
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "</tr>"		
								Add-Content  DBAudit.html  "<tr>"
								Add-Content  DBAudit.html  "<td>"
								Add-Content  DBAudit.html  "Total WebApplication Processed"
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "<td>"
								Add-Content  DBAudit.html    $webcount # Web Application count
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "</tr>"
								Add-Content  DBAudit.html  "<tr>"
								Add-Content  DBAudit.html  "<td>"
								Add-Content  DBAudit.html  "Total Database Processed"
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "<td>"
								Add-Content  DBAudit.html    $dbcount # Database Count
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "</tr>"
								Add-Content  DBAudit.html  "<tr>"
								Add-Content  DBAudit.html  "<td>"
								Add-Content  DBAudit.html  "Total SiteCollection Processed"
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "<td>"
								Add-Content  DBAudit.html   $sccount # site collection count
								Add-Content  DBAudit.html  "</td>"
								Add-Content  DBAudit.html  "</tr>"
								Add-Content   DBAudit.html  "</table>"
								Add-Content   DBAudit.html "</body>"						
								Add-Content   DBAudit.html "<html>"												
								$WebPro.Text = "Total WebApplication Processed: $webcount "
								$WebPro.Refresh()
								$DBPro.Text = "Total Database Processed: $dbcount "
								$DBPro.Refresh()
								$SCPro.Text = "Total SiteCollection Processed:	$sccount "
								$SCPro.Refresh()	
								[System.Windows.Forms.MessageBox]::Show("Operation Completed", "Message") 					
								#$DBAuditForm.Close()
								#$DBAuditForm.Dispose()		
								Invoke-Item  DBAudit.html	
								$WebAuditLevel.Visible = $false
								$WebAuditButton.visible =$false
								$WebAppList.Visible = $false
								$FARMAuditButton.Visible = $true
								$WebPro.Text = ""
								$WebPro.Refresh()
								$DBPro.Text = ""
								$DBPro.Refresh()
								$SCPro.Text = ""
								$SCPro.Refresh()
								Write-Host "Operation Completed"
							}
							else
							{
								[System.Windows.Forms.MessageBox]::Show("Invalid Selection", "Error") 
							}
					})				
					
					break															
				}
		# Database level Audit
                ("Database Level")
                {
                    $DBPro.Visible = $true
                    $DBPro.Text = " "
                    $DBPro.Refresh()								
                    $SCPro.Visible = $true
                    $SCPro.Text = " "
                    $SCPro.Refresh()									
                    $FARMAuditButton.Visible = $false			
                    # Database Audit Button
                    $DBAuditButton = New-Object System.Windows.Forms.Button
                    $DBAuditButton.Location = New-Object System.Drawing.Size(88, 46)
                    $DBAuditButton.Size =  New-Object System.Drawing.Size(75, 21)
                    $DBAuditButton.Text = "Start"
                    $DBAuditForm.Controls.Add($DBAuditButton)	
                    $DBList = New-Object System.Windows.Forms.ListBox
                    $DBList.Location = New-Object System.Drawing.Size(338, 19)
                    $DBList.Size = New-Object System.Drawing.Size(271, 69)
                    $contentdb = Get-SPContentDatabase -ErrorAction Stop
                    # Getting list of Database
                    foreach($db in $contentdb)
                    {
                        $DBList.Items.Add($db.Name)
                    }
                    # Allowing multiple Selection
                    $DBList.SelectionMode = "MultiExtended"
                    $DBAuditForm.Controls.Add($DBList)
                    $DBAuditLevel = New-Object System.Windows.Forms.Label
                    $DBAuditLevel.Location = New-Object System.Drawing.Size(264, 19)
                    $DBAuditLevel.Size = New-Object System.Drawing.Size(58, 13)
                    $DBAuditLevel.Text = "DB Name"
                    $DBAuditForm.Controls.Add($DBAuditLevel)	
                    # Execution
                    $DBAuditButton.Add_Click({
                                    if(($DBList.SelectedItems).Count -gt 0)
                                    {
                                        # Creating File
                                        New-Item -ItemType File -Name  DBAudit.html -Force
                                        # Adding HTML Tags and Information  in File
                                        Add-Content  DBAudit.html "<html xmlns=""http://www.w3.org/1999/xhtml"" >"
                                        Add-Content  DBAudit.html  "<head>"
                                        Add-Content  DBAudit.html  "<title>DB Audit Report - Database  Level</title>"
                                        Add-Content  DBAudit.html  "</head>"
                                        Add-Content  DBAudit.html  "<body>"				
                                        # Creating HTML table
                                        Add-Content  DBAudit.html  "<table border=1 bordercolor=#FFCC00 style= font-family:Candara,arial,sans-serif;font-size:13px width=80% cellpadding=3 cellspacing=3>"											
                                        [int] $dbcount = 0
                                        [int] $sccount = 0
                                        [float] $totaldbsize = 0
                                        Add-Content  DBAudit.html  "<tr>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html  "Audit Type"
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html    "Database Level"
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "</tr>"
                                        Add-Content  DBAudit.html  "<tr>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html  "User"
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html    $userdomain"\"$user # User Name
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "</tr>"
                                        Add-Content  DBAudit.html  "<tr>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html  "Machine Name"
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html    $machine # Machine Name
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "</tr>"
                                        Add-Content  DBAudit.html  "<tr>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html  "Date"	
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html    $date # Current Date
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "</tr>"	
                                        #[array] $temp =  $DBList.SelectedItems
                                        # Processing for each Selected Database
                                        foreach($dbp in $DBList.SelectedItems )
                                        {
                                                Write-Host $dbp
                                                $DBPro.Visible = $true
                                                $DBPro.Text = "Processing for $dbp"
                                                $DBPro.Refresh()											
                                                # Getting DB details
                                                $dbd = Get-SPContentDatabase -Identity $dbp -ErrorAction SilentlyContinue																
                                                # collecting Sitec collection within DB
                                                $dbf = Get-SPSite -ContentDatabase $dbd -Limit All 	 -ErrorAction SilentlyContinue
                                                # Getting Database size in GB (Total Disk space required for backup)
                                                [float] $dbSize = $dbd.disksizerequired/1GB													
                                                $dbSize = [System.Math]::Round($dbsize, 2) 			
                                                Write-Host $dbSize
                                                # float variable to calculate totol site collection size within DB		
                                                $totaldbsize = $totaldbsize + $dbSize
                                                [float] $totalmb = 0
                                                Add-Content  DBAudit.html  "<tr>"
                                                Add-Content  DBAudit.html  "<td  bgcolor=#FFCC99>"
                                                Add-Content  DBAudit.html  "Database Name \ Server \ Farm \ Id \ IsReadOnly  "
                                                Add-Content  DBAudit.html  "</td>"
                                                Add-Content  DBAudit.html  "<td bgcolor=#FFCC99 aligned =justify >"		
                                                Add-Content  DBAudit.html  "<B><I>"
                                                Add-Content  DBAudit.html  $dbd.Name # Database Name
                                                Add-Content  DBAudit.html "</B></I>"													
                                                Add-Content  DBAudit.html	"\ "			
                                                Add-Content  DBAudit.html	$dbd.Server		# Database Server Name					 
                                                Add-Content  DBAudit.html	"\ "
                                                Add-Content  DBAudit.html	$dbd.FARM	# Associated with FARM
                                                Add-Content  DBAudit.html	"\ "
                                                Add-Content  DBAudit.html	$dbd.ID	 # DB GUID
                                                Add-Content  DBAudit.html	"\ "
                                                Add-Content  DBAudit.html	$dbd.IsReadOnly		# Database IsReadOnly - True/False																						
                                                Add-Content  DBAudit.html  "</td>"
                                                Add-Content  DBAudit.html  "</tr>"		
                                                Add-Content  DBAudit.html  "<tr>"
                                                Add-Content  DBAudit.html  "<td >"
                                                Add-Content  DBAudit.html  "Size of the Database (Total Disk Space)"
                                                Add-Content  DBAudit.html  "</td>"
                                                Add-Content  DBAudit.html  "<td  >"	
                                                Add-Content  DBAudit.html 	$dbSize # Database Size
                                                Add-Content  DBAudit.html  "GB"
                                                Add-Content  DBAudit.html  "</td>"
                                                Add-Content  DBAudit.html  "</tr>"
                                                Add-Content  DBAudit.html  "<tr>"
                                                Add-Content  DBAudit.html  "<td >"
                                                Add-Content  DBAudit.html  "Total number of site collections"
                                                Add-Content  DBAudit.html  "</td>"
                                                Add-Content  DBAudit.html  "<td >"	
                                                Add-Content  DBAudit.html  $dbd.currentsitecount # Total number of DB
                                                Add-Content  DBAudit.html  "</td>"
                                                Add-Content  DBAudit.html  "</tr>"		
                                                Write-Host "Site Collection "$dbd.Count # Displaying @ console
                                                Add-Content  DBAudit.html  "<tr>"
                                                Add-Content  DBAudit.html  "<td>"
                                                Add-Content  DBAudit.html  "Site Collection URL"															
                                                Add-Content  DBAudit.html  "</td>"
                                                Add-Content  DBAudit.html  "<td>"
                                                Add-Content  DBAudit.html  "Size  -SCA - Last ModifiedDate"															
                                                Add-Content  DBAudit.html  "</td>"	
                                                Add-Content  DBAudit.html  "</tr>"
                                                # Processing for Site collection
                                                foreach($sc in $dbf)										
                                                {												
                                                    $SCPro.Visible = $true
                                                    $SCPro.Text = "Processing for $sc"
                                                    $SCPro.Refresh()
                                                    Write-Host $sc
                                                    Add-Content  DBAudit.html  "<tr>"
                                                    Add-Content  DBAudit.html  "<td>"
                                                    Add-Content  DBAudit.html  $sc.url		
                                                    Add-Content  DBAudit.html  "</td>"							
                                                    Add-Content  DBAudit.html  "<td>"
                                                    # if Site collectionusage space is -gt or -eq 1024 convrt it into GB
                                                    if((($sc.usage.storage/1MB) -gt 1024) -or (($sc.usage.storage/1MB) -eq 1024))
                                                    {
                                                        [float] $scsize  =$sc.usage.storage/1GB
                                                        $scsize = [System.Math]::Round($scsize, 2) 
                                                        Add-Content  DBAudit.html	$scsize" GB"
                                                    }
                                                    else
                                                    {
                                                        [float] $scsize = $sc.usage.storage/1MB
                                                        $scsize = [System.Math]::Round($scsize, 2) 
                                                        Add-Content  DBAudit.html	$scsize" MB"
                                                    }		
                                                    Add-Content  DBAudit.html  "-"
                                                    Add-Content  DBAudit.html  $sc.Owner
                                                    Add-Content  DBAudit.html  "-"														
                                                    Add-Content  DBAudit.html  $sc.LastContentModifiedDate 
                                                    Add-Content  DBAudit.html  "</td>"
                                                    Add-Content  DBAudit.html  "</tr>"
                                                    # Adding total site collection (within DB) size
                                                    $totalmb = $totalmb +($sc.usage.storage/1MB)
                                                    # Incrementing Processed site collection count 
                                                    $sccount ++
                                                }	
                                            # Incrementing Processed site collection count  within DB
                                            $sccount =+ $sccount
                                            # Converting Total size of Site collections with DB
                                            $totalmb  =$totalmb/1024
                                            $totalmb = [System.Math]::Round($totalmb, 2)
                                            Add-Content  DBAudit.html  "<tr>"
                                            Add-Content  DBAudit.html  "<td>"
                                            Add-Content  DBAudit.html  "Site Collection (Total size)"
                                            Add-Content  DBAudit.html  "</td>"							
                                            Add-Content  DBAudit.html  "<td>"
                                            Add-Content  DBAudit.html $totalmb" GB"
                                            Add-Content  DBAudit.html  "</td>"
                                            Add-Content  DBAudit.html  "</tr>"
                                            # Incrementing Processed  DB count 
                                            $dbcount++
                                        }	
                                        $totaldbsize =+$totaldbsize
                                    #}														
                                    # Incrementing Processed  Site collection count within Web Application
                                    $sccount =+ $sccount
                                    # Incrementing Processed  DB count within Web Application
                                    $dbcount =+ $dbcount						
                                    # Summary
                                        Add-Content  DBAudit.html  "<tr>"
                                        Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"	
                                        Add-Content  DBAudit.html  "Total Database Size (Disk Space required)"
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "<td bgcolor =#FFCC66>"	
                                        Add-Content  DBAudit.html 	$totaldbsize" GB" # Database Size
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "</tr>"	
                                        Add-Content  DBAudit.html  "<tr>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html  "Total Database Processed"
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html    $dbcount # Database count
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "</tr>"
                                        Add-Content  DBAudit.html  "<tr>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html  "Total SiteCollection Processed"
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "<td>"
                                        Add-Content  DBAudit.html   $sccount # Site Collection Count
                                        Add-Content  DBAudit.html  "</td>"
                                        Add-Content  DBAudit.html  "</tr>"
                                        Add-Content   DBAudit.html  "</table>"
                                        Add-Content   DBAudit.html "</body>"						
                                        Add-Content   DBAudit.html "<html>"	
                                        $DBPro.Text = "Total Database Processed: $dbcount "
                                        $DBPro.Refresh()
                                        $SCPro.Text = "Total SiteCollection Processed:	$sccount "
                                        $SCPro.Refresh()	
                                        [System.Windows.Forms.MessageBox]::Show("Operation Completed", "Message") 					
                                        #$DBAuditForm.Close()
                                        #$DBAuditForm.Dispose()																
                                        Invoke-Item  DBAudit.html	
                                        $DBAuditLevel.Visible = $false
                                        $DBAuditButton.visible =$false
                                        $DBList.Visible = $false
                                        $FARMAuditButton.Visible = $true
                                        $DBPro.Text = ""
                                        $DBPro.Refresh()
                                        $SCPro.Text = ""
                                        $SCPro.Refresh()
                                        Write-Host "Operation Completed"
                                    }
                                    else
                                    {
                                        [System.Windows.Forms.MessageBox]::Show("Invalid Selection", "Error") 
                                    }
                                    
                    })	
                    break
                }									
	        }
})	
		$DBAuditForm.Controls.Add($FARMAuditButton)							
	#Activating Form
		$DBAuditForm.Add_Shown({$DBAuditForm.Activate()})
	# Close Form
		$DBAuditCloseButton = New-Object System.Windows.Forms.Button
		$DBAuditCloseButton.Location = New-Object System.Drawing.Size(171, 46)
		$DBAuditCloseButton.Size =  New-Object System.Drawing.Size(75, 21)
		$DBAuditCloseButton.Text = "Close"
		$DBAuditCloseButton.Add_Click({		
									# Closing Installation Form
										$DBAuditForm.Close()  	
									# Disposing Object
										$DBAuditForm.Dispose()																	
								})
		$DBAuditForm.Controls.Add($DBAuditCloseButton)
		$DBAuditForm.ShowDialog()		
		cls
#############################################################################################################################