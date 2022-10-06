// Example file for CAN SPI project
#include "CAN.h"
#include "CAN_Driver.h"

void CAN_App(void)
{
    char dataRxTx[ 8 ] = { 0 };
    uint8_t dataRxLen = 0;
    uint8_t msgRcvd = 0;
    uint8_t dataTx = 0;
    uint32_t idRx = 0;
    uint8_t canRcvFlags = 0;

    dataTx = 0xAB;

    msgRcvd = CANSPIRead( &idRx , &dataRxTx[ 0 ] , &dataRxLen, &canRcvFlags );

    if ( msgRcvd )
    {
        mikrobus_logWrite( &dataRxTx[ 0 ], _LOG_BYTE );
        Delay_1sec();
    }

//    CANSPIWrite( id2nd, dataTx, 1, canSendFlags );
//    mikrobus_logWrite( "MESSAGE SENT", _LOG_LINE );
//    Delay_1sec();
}