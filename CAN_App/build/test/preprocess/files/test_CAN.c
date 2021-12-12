#include "build/test/mocks/mock_CAN_Driver.h"
#include "src/CAN.h"
#include "C:/Users/John/Documents/GitHub/MadScienceLabDocker/CAN_App/vendor/ceedling/vendor/unity/src/unity.h"








void setUp(void)

{

}



void tearDown(void)

{

}



void test_GivenMessageReceived_ThenWritesToLog(void)

{

    CANSPIRead_CMockExpectAndReturn(18, 0, 0, 0, 0, 1);

    CANSPIRead_CMockIgnoreArg_idRx(19);

    CANSPIRead_CMockIgnoreArg_dataRxTx(20);

    CANSPIRead_CMockIgnoreArg_dataRxLen(21);

    CANSPIRead_CMockIgnoreArg_canRcvFlags(22);

    CANSPIRead_CMockReturnMemThruPtr_dataRxTx(23, "ABCDEFG", sizeof(uint8_t));

    mikrobus_logWrite_CMockExpect(24, "ABCDEFG", _LOG_BYTE);

    Delay_1sec_CMockExpect(25);



    CAN_App();

}



void test_GivenNoMessageReceived_ThenDoesNotWriteToLog(void)

{

    CANSPIRead_CMockExpectAndReturn(32, 0, 0, 0, 0, 0);

    CANSPIRead_CMockIgnoreArg_idRx(33);

    CANSPIRead_CMockIgnoreArg_dataRxTx(34);

    CANSPIRead_CMockIgnoreArg_dataRxLen(35);

    CANSPIRead_CMockIgnoreArg_canRcvFlags(36);

    CANSPIRead_CMockReturnMemThruPtr_dataRxTx(37, "ABCDEFG", sizeof(uint8_t));



    CAN_App();

}
