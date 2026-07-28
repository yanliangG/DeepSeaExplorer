import cv2
import time
from custom.openpose_model import OpenposeModel
import keyboard
import udp.UdpComms as U

# Initialize a counter
counter = 0

# Create UDP socket to use for sending (and receiving)
sock = U.UdpComms(udpIP="127.0.0.1", portTX=8000, portRX=8001, enableRX=True, suppressWarnings=True)

if __name__ == "__main__":
    # Start the loop
    start_time = time.time()

    # Initialize video capture for two webcams
    cap1 = cv2.VideoCapture(0)  # First webcam (default)
    # cap2 = cv2.VideoCapture(1)  # Second webcam (phone)

    # Check if the webcams are opened successfully
    if not cap1.isOpened():
        print("Error: Could not open webcam 1.")
        exit()
    # if not cap2.isOpened():
    #     print("Error: Could not open webcam 2.")
    #     exit()

    openpose_model = OpenposeModel()
    start_game = True
    swimming_count = 0
    turn = 'n'

    while True:
        # Read frames from both webcams
        ret1, frame1 = cap1.read()
        # ret2, frame2 = cap2.read()

        # if not ret1 or not ret2:
        #     print("Error: Could not read frames from one or both webcams.")
        #     break
        
        if start_game:
            if frame1 is None: continue
            else:
                result, keypoints = openpose_model(frame1)

                sock.SendData(f'Swimming count: {swimming_count}{turn}') # Send this string to other application
                swimming_count = 0
                turn = 'n'

                # data = sock.ReadReceivedData() # read data

                # if data != None: # if NEW data has been received since last ReadReceivedData function call
                #     print(f"From Unity: {data}") # print new received data

                print("turn: ")
                openpose_model.get_hands_position()
                openpose_model.check_swimming()
                # turn0, turn1 = openpose_model.get_head_turn()
                turn = openpose_model.check_turn()
                print(turn)
                # print(str(turn0) + " " + str(turn1))
                if(openpose_model.is_swimming):
                    swimming_count = 1
                    print("swimming")
                    print(f"Swimming count: {swimming_count}")
                # else:
                #     print("NOT")
                
                # We send this frame to GazeTracking to analyze it
                # gaze.refresh(frame2)

                # frame = gaze.annotated_frame()
                # text = ""
                # if gaze.is_blinking():
                #     text = "Blinking"
                # elif gaze.is_right():
                #     text = "Looking left"
                #     turn = 'l'
                # elif gaze.is_left():
                #     text = "Looking right"
                #     turn = 'r'
                # elif gaze.is_center():
                #     text = "Looking center"
                # print(text)
                print("-------------------")
        
        # Display the frames in separate windows
        cv2.imshow('Webcam 1', frame1)
        # cv2.imshow('Webcam 2', frame2)

        # Calculate how much time has passed
        elapsed_time = time.time() - start_time

        # Sleep for the remaining time to maintain 10 iterations per second
        time_to_sleep = max(0, 0.1 - elapsed_time)
        time.sleep(time_to_sleep)

        # Reset start time for the next iteration
        start_time = time.time()

        # Break the loop when 'q' is pressed
        if cv2.waitKey(1) == 27:
            start_game = False
            break
        
        # Start openpose model when 's' is pressed 
        # if keyboard.is_pressed('s'):
        #     start_game = True

        # End the program when 'q' is pressed 
        if keyboard.is_pressed('q'):
            start_game = True


    # Release resources
    cap1.release()
    # cap2.release()
    cv2.destroyAllWindows()