using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenManager : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //每一秒钟打印当前游戏界面的分辨率
        if (Time.frameCount % 60 == 0) // Assuming the game runs at 60 FPS
        {
            PrintResolution();
        }
    }

    //每一秒钟打印当前游戏界面的分辨率
    void PrintResolution()
    {
        Debug.Log("Current Resolution: " + Screen.width + "x" + Screen.height);
    }
}
