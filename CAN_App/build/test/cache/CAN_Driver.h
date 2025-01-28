









typedef enum logOpt

{

    _LOG_BYTE,

    _LOG_LINE

 } LOGOPT_t;



uint8_t CANSPIRead( uint32_t *idRx , uint8_t *dataRxTx , uint8_t *dataRxLen, uint8_t *canRcvFlags );

void mikrobus_logWrite( uint8_t *dataRxTx, const LOGOPT_t opt );

void Delay_1sec( void );
