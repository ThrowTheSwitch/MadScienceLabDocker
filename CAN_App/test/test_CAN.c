#ifdef TEST

#include "unity.h"

#include "CAN.h"
#include "mock_CAN_Driver.h"

void setUp(void)
{
}

void tearDown(void)
{
}

void test_GivenMessageReceived_ThenWritesToLog(void)
{
    CANSPIRead_ExpectAndReturn( 0,0,0,0, 1);
    CANSPIRead_IgnoreArg_idRx();
    CANSPIRead_IgnoreArg_dataRxTx();
    CANSPIRead_IgnoreArg_dataRxLen();
    CANSPIRead_IgnoreArg_canRcvFlags();
    CANSPIRead_ReturnThruPtr_dataRxTx("ABCDEFG");
    mikrobus_logWrite_Expect("ABCDEFG", _LOG_BYTE);
    Delay_1sec_Expect();

    CAN_App();
}

void test_GivenNoMessageReceived_ThenDoesNotWriteToLog(void)
{
    CANSPIRead_ExpectAndReturn( 0,0,0,0, 0);
    CANSPIRead_IgnoreArg_idRx();
    CANSPIRead_IgnoreArg_dataRxTx();
    CANSPIRead_IgnoreArg_dataRxLen();
    CANSPIRead_IgnoreArg_canRcvFlags();
    CANSPIRead_ReturnThruPtr_dataRxTx("ABCDEFG");
    
    CAN_App();
}

#endif // TEST
