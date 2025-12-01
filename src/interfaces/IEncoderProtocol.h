#ifndef IENCODERPROTOCOL_H
#define IENCODERPROTOCOL_H

#include <QObject>

/**
 * @brief Strategy pattern interface for encoder data parsing
 * @details Enables Open/Closed Principle - new protocols can be added
 * without modifying existing code.
 */
class IEncoderProtocol {
public:
    virtual ~IEncoderProtocol() = default;

    /**
     * @brief Parse raw encoder data to position value
     * @param data Raw bytes from serial port
     * @return Parsed position in degrees, or NaN if parsing fails
     */
    virtual float parsePosition(const QByteArray& data) = 0;

    /** @brief Get command to request encoder position */
    virtual QByteArray getReadCommand() const = 0;

    /** @brief Get command to zero encoder */
    virtual QByteArray getZeroCommand() const = 0;
};

#endif // IENCODERPROTOCOL_H
