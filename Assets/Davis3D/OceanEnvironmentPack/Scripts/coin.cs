using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]

public class coin : MonoBehaviour
{
    public int count = 0;

    public TextMeshProUGUI coinText;
    AudioSource audioData;

    private void Start()
    {
        coinText.text = "Coins: 0";
        audioData = GetComponent<AudioSource>();
    }

    private void Update()
    {
        if (count == 12)
        {
            coinText.text = "You Won!";
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.transform.tag == "Coin")
        {
            Destroy(other.gameObject);
            count++;
            coinText.text = "Coins: " + count.ToString();
            audioData.Play(0);
            // Debug.Log(count);
            
        }

    }
    



}
