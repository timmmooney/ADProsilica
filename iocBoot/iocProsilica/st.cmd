< envPaths
errlogInit(20000)

dbLoadDatabase("$(AD)/dbd/prosilicaApp.dbd")
prosilicaApp_registerRecordDeviceDriver(pdbbase) 

prosilicaConfig("PS1", 50110, 50, 200000000)
#prosilicaConfig("PS1", 50022)
dbLoadRecords("$(AD)/ADApp/Db/ADBase.template",   "P=13PS1:,R=cam1:,PORT=PS1,ADDR=0,TIMEOUT=1")
dbLoadRecords("$(AD)/ADApp/Db/prosilica.template","P=13PS1:,R=cam1:,PORT=PS1,ADDR=0,TIMEOUT=1")

prosilicaConfig("PS2", 50022, 10, 50000000)
dbLoadRecords("$(AD)/ADApp/Db/ADBase.template",   "P=13PS1:,R=cam2:,PORT=PS2,ADDR=0,TIMEOUT=1")
dbLoadRecords("$(AD)/ADApp/Db/prosilica.template","P=13PS1:,R=cam2:,PORT=PS2,ADDR=0,TIMEOUT=1")

# Create a standard arrays plugin, set it to get data from first Prosilica driver.
drvNDStdArraysConfigure("PS1Image", 5, 0, "PS1", 0, -1)
dbLoadRecords("$(AD)/ADApp/Db/NDPluginBase.template","P=13PS1:,R=image1:,PORT=PS1Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=PS1,NDARRAY_ADDR=0")
dbLoadRecords("$(AD)/ADApp/Db/NDStdArrays.template", "P=13PS1:,R=image1:,PORT=PS1Image,ADDR=0,TIMEOUT=1,SIZE=8,FTVL=UCHAR,NELEMENTS=1392640")

# Create a file saving plugin
drvNDFileConfigure("PS1File", 5, 0, "PS1", 0)
dbLoadRecords("$(AD)/ADApp/Db/NDPluginBase.template","P=13PS1:,R=file1:,PORT=PS1File,ADDR=0,TIMEOUT=1,NDARRAY_PORT=PS1,NDARRAY_ADDR=0")
dbLoadRecords("$(AD)/ADApp/Db/NDFile.template",      "P=13PS1:,R=file1:,PORT=PS1File,ADDR=0,TIMEOUT=1")

# Create an ROI plugin
drvNDROIConfigure("PS1ROI", 5, 0, "PS1", 0, 10, -1)
dbLoadRecords("$(AD)/ADApp/Db/NDPluginBase.template","P=13PS1:,R=ROI1:,  PORT=PS1ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=PS1,NDARRAY_ADDR=0")
dbLoadRecords("$(AD)/ADApp/Db/NDROI.template",       "P=13PS1:,R=ROI1:,  PORT=PS1ROI,ADDR=0,TIMEOUT=1")
dbLoadRecords("$(AD)/ADApp/Db/NDROIN.template",      "P=13PS1:,R=ROI1:0:,PORT=PS1ROI,ADDR=0,TIMEOUT=1,HIST_SIZE=256")
dbLoadRecords("$(AD)/ADApp/Db/NDROIN.template",      "P=13PS1:,R=ROI1:1:,PORT=PS1ROI,ADDR=1,TIMEOUT=1,HIST_SIZE=256")
dbLoadRecords("$(AD)/ADApp/Db/NDROIN.template",      "P=13PS1:,R=ROI1:2:,PORT=PS1ROI,ADDR=2,TIMEOUT=1,HIST_SIZE=256")
dbLoadRecords("$(AD)/ADApp/Db/NDROIN.template",      "P=13PS1:,R=ROI1:3:,PORT=PS1ROI,ADDR=3,TIMEOUT=1,HIST_SIZE=256")


#asynSetTraceMask("PS1",0,255)

set_requestfile_path("./")
set_savefile_path("./autosave")
set_requestfile_path("$(AD)/ADApp/Db")
set_pass0_restoreFile("auto_settings.sav")
set_pass1_restoreFile("auto_settings.sav")
save_restoreSet_status_prefix("13PS1:")
dbLoadRecords("$(AUTOSAVE)/asApp/Db/save_restoreStatus.db", "P=13PS1:")

iocInit()

# save things every thirty seconds
create_monitor_set("auto_settings.req", 30,"P=13PS1:,D=cam1:")
