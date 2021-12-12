// Example file for CAN SPI project
#include main.h
#include CAN.h

void main(void)
{
    char dataRxTx[ 8 ];
    uint8_t dataRxLen;
    uint8_t msgRcvd;
    uint8_t dataTx;
    uint32_t idRx;
    uint8_t canRcvFlags;

    dataTx = 0xAB;

    msgRcvd = CANSPIRead( &idRx , &dataRxTx , &dataRxLen, &canRcvFlags );

    if ( msgRcvd )
    {
        mikrobus_logWrite( &dataRxTx, _LOG_BYTE );
        Delay_1sec();
    }

//    CANSPIWrite( id2nd, dataTx, 1, canSendFlags );
//    mikrobus_logWrite( "MESSAGE SENT", _LOG_LINE );
//    Delay_1sec();
}